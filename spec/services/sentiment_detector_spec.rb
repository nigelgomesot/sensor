require 'rails_helper'

RSpec.describe SentimentDetector, type: :service do
  let(:message) { FactoryBot.create(:message) }

  describe '#initialize' do
    let(:messages) { [] }

    it 'assigns attributes' do
      detector = SentimentDetector.new(messages)

      expect(detector.messages).to match_array(messages)
      expect(detector.sentiments).to be_empty
      expect(detector.aws_client).to be_an_instance_of(Clients::Aws)
    end
  end

  describe '#execute!' do
    let(:detector) { SentimentDetector.new(messages) }

    context 'with messages length' do
      context 'when messages are empty' do
        let(:messages) { [] }

        it 'raises an error' do
          expect do
            detector.execute!
          end.to raise_error(RuntimeError, /number of messages expected:/)
        end
      end

      context 'when messages length > MESSAGES_MAX_LENGTH' do
        let(:messages) { [message] }

        it 'raises an error' do
          stub_const("#{SentimentDetector}::MESSAGES_MAX_LENGTH", 0)

          expect do
            detector.execute!
          end.to raise_error(RuntimeError, /number of messages expected/)
        end
      end
    end

    context 'AWS responses' do
      let(:messages) { [message] }
      let(:service_stub) do
        Aws::Comprehend::Client.new(stub_responses: true)
      end
      let(:aws_client_stub) { Clients::Aws.new(service_stub) }

      before(:each) do
        expect(detector).to receive(:aws_client)
          .and_return(aws_client_stub)
      end

      it 'raises an error for AWS error response' do
        error = StandardError.new('AWS SDK error')
        service_stub.stub_responses(
          :batch_detect_sentiment,
          error,
        )

        expect do
          detector.execute!
        end.to raise_error(RuntimeError, /AWS SDK error/)
      end
    end
  end
end
