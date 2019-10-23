require 'rails_helper'

RSpec.describe EntityDetector, type: :service do
  let(:message) { FactoryBot.create(:message, text: 'April 23 Chicago') }

  describe '#initialize' do
    let(:message_ids) { [message.id] }

    it 'assigns attributes' do
      detector = EntityDetector.new(message_ids)

      expect(detector.message_ids).to match_array(message_ids)
      expect(detector.messages).to be_empty
      expect(detector.entities).to be_empty
      expect(detector.aws_client).to be_an_instance_of(Clients::Aws)
    end
  end

  describe '#execute!' do
    let(:detector) { EntityDetector.new(message_ids) }

    context 'with messages length' do
      context 'when messages are empty' do
        let(:message_ids) { [] }

        it 'raises an error' do
          expect do
            detector.execute!
          end.to raise_error(RuntimeError, /number of messages expected:/)
        end
      end

      context 'when messages length > MESSAGES_MAX_LENGTH' do
        let(:message_ids) { [message.id] }

        it 'raises an error' do
          stub_const("#{EntityDetector}::MESSAGES_MAX_LENGTH", 0)

          expect do
            detector.execute!
          end.to raise_error(RuntimeError, /number of messages expected/)
        end
      end
    end

    context 'AWS responses' do
      let(:message_ids) { [message.id] }
      let(:service_stub) do
        Aws::Comprehend::Client.new(stub_responses: true)
      end
      let(:aws_client_stub) { Clients::Aws.new(service_stub) }

      before(:each) do
        expect(detector).to receive(:aws_client)
          .and_return(aws_client_stub)
      end

      it 'raises an error for AWS error response' do
        error = RuntimeError.new('AWS error')
        service_stub.stub_responses(
          :batch_detect_entities,
          error,
        )

        expect do
          detector.execute!
        end.to raise_error(RuntimeError, /AWS error/)
      end

      it 'raises an error for AWS response with error list' do
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

        expected_error_log = "detect entities error for message_id: #{message.id}, code: error_code, message: error_message"
        expect(Rails.logger).to receive(:error)
          .with(expected_error_log).and_call_original

        expect do
          detector.execute!
        end.to raise_error(StandardError, /AWS error/)
      end

      it 'creates entities for messages' do
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
          :batch_detect_entity,
          response_body,
        )

        expect do
          detector.execute!
        end.to change { Entity.count }.from(0).to(2)

        entity1 = Entity.find_by(category: 'date')
        expect(entity1.message).to eq(message)
        expect(entity1.user).to eq(message.user)
        expect(entity1.text).to eq('April 23')
        expect(entity1.score).to eq(0.9972403049468994)

        entity2 = Entity.find_by(category: 'location')

        expect(entity1.message).to eq(message)
        expect(entity1.user).to eq(message.user)
        expect(entity1.text).to eq('Chicago')
        expect(entity1.score).to eq(0.9716717004776001)
      end
    end
  end
end

