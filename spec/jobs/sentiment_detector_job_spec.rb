require 'rails_helper'

RSpec.describe SentimentDetectorJob, type: :job do
  let(:message) { FactoryBot.create(:message) }
  let(:message_ids) { [message.id] }

  let(:service_stub) do
    Aws::Comprehend::Client.new(stub_responses: true)
  end
  let(:aws_client_stub) { Clients::Aws.new(service_stub) }

  before(:each) do
    expect_any_instance_of(SentimentDetector).to receive(:aws_client)
      .and_return(aws_client_stub)
  end

  it 'executes the job' do
    response_body = {
      :result_list=>[
        {
          :index=>0,
          :sentiment=>"POSITIVE",
          :sentiment_score=>{
            :positive=>0.98,
            :negative=>0.0,
            :neutral=>0.01,
            :mixed=>1.51
          }
        }
      ],
      :error_list=>[]
    }

    service_stub.stub_responses(
      :batch_detect_sentiment,
      response_body,
    )

    expect do
      SentimentDetectorJob.perform_now(message_ids)
    end.to change { Sentiment.count }.from(0).to(1)
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
        :batch_detect_sentiment,
        response_body,
      )

      expect do
        SentimentDetectorJob.perform_now(message_ids)
      end.to raise_error(StandardError, /AWS error/)
        .and change { Sentiment.count }.by(0)
    end
  end
end
