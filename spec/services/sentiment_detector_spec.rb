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
end
