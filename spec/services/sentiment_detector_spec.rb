require 'rails_helper'

RSpec.describe SentimentDetector, type: :service do
  let(:message) { FactoryBot.create(:message) }

  describe '#initialize' do
    let(:message_ids) { [message.id] }

    it 'assigns attributes' do
      detector = SentimentDetector.new(message_ids)

      expect(detector.message_ids).to match_array(message_ids)
      expect(detector.messages).to be_empty
      expect(detector.sentiments).to be_empty
      expect(detector.aws_client).to be_an_instance_of(Clients::Aws)
    end
  end

  describe '#execute!' do
    let(:detector) { SentimentDetector.new(message_ids) }

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
          stub_const("#{SentimentDetector}::MESSAGES_MAX_LENGTH", 0)

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
          :batch_detect_sentiment,
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
          :batch_detect_sentiment,
          response_body,
        )

        expected_error_log = "detect sentiment error for message_id: #{message.id}, code: error_code, message: error_message"
        expect(Rails.logger).to receive(:error)
          .with(expected_error_log).and_call_original

        expect do
          detector.execute!
        end.to raise_error(StandardError, /AWS error/)
      end

      it 'creates sentiment for messages' do
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
          detector.execute!
        end.to change { Sentiment.count }.from(0).to(1)

        sentiment = Sentiment.last
        expect(sentiment.message).to eq(message)
        expect(sentiment.user).to eq(message.user)
        expect(sentiment.level).to eq('positive')
        expect(sentiment.mixed_score).to eq(1.51)
        expect(sentiment.negative_score).to eq(0.0)
        expect(sentiment.neutral_score).to eq(0.01)
        expect(sentiment.positive_score).to eq(0.98)
      end
    end
  end
end
