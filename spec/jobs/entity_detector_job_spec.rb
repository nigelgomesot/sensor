require 'rails_helper'

RSpec.describe EntityDetectorJob, type: :job do
  let(:message) { FactoryBot.create(:message) }
  let(:message_ids) { [message.id] }

  let(:service_stub) do
    Aws::Comprehend::Client.new(stub_responses: true)
  end
  let(:aws_client_stub) { Clients::Aws.new(service_stub) }

  before(:each) do
    expect_any_instance_of(EntityDetector).to receive(:aws_client)
      .and_return(aws_client_stub)
  end

  it 'executes the job' do
    response_body = {
      :result_list=>[
        {
          :index=>0,
          :entities=>[
            {
              :score=>0.9972403049468994,
              :type=>"DATE",
              :text=>"April 23",
              :begin_offset=>0,:end_offset=>8
            },
            {
              :score=>0.9716717004776001,
              :type=>"LOCATION",
              :text=>"Chicago",
              :begin_offset=>9,
              :end_offset=>16
            }
          ]
        }
      ],
      :error_list=>[]
    }

    service_stub.stub_responses(
      :batch_detect_entities,
      response_body,
    )

    expect do
      EntityDetectorJob.perform_now(message_ids)
    end.to change { Entity.count }.from(0).to(2)
  end

  context 'when slack API returns error' do

    it 'raises RuntimeError and aborts the job' do
      response_body = {
        :error_list=>[
          {
            :index => 0,
            :error_code => 'error_code',
            :error_message => 'error_message',
          }
        ],
        :result_list=>[]
      }

      service_stub.stub_responses(
        :batch_detect_entities,
        response_body,
      )

      expect do
        EntityDetectorJob.perform_now(message_ids)
      end.to raise_error(StandardError, /AWS error/)
        .and change { Entity.count }.by(0)
    end
  end
end
