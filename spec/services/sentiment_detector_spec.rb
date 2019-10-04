require 'rails_helper'

RSpec.describe SentimentDetector, type: :service do

  describe '#initialize' do
    let(:messages)  do
      []
    end
    it 'assigns attributes' do
      detector = SentimentDetector.new(messages)

      expect(detector.messages).to match_array(messages)
      expect(detector.sentiments).to be_empty
      expect(detector.aws_client).to be_an_instance_of(Clients::Aws)
    end
  end

  describe '#execute!' do
    let(:detector) { SentimentDetector.new(messages) }
    let(:messages) { [] }

    it 'raises error is messages is empty' do
      expect do
        detector.execute!
      end.to raise_error(RuntimeError, /number of messages expected:/)
    end

    it 'raises error is messages length > MESSAGES_MAX_LENGTH' do
      stub_const("#{SentimentDetector}::MESSAGES_MAX_LENGTH", 0)

      messages = [1]

      expect do
        detector.execute!
      end.to raise_error(RuntimeError, /number of messages expected/)
    end
  end
end
