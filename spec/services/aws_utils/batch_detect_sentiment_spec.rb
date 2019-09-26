require 'rails_helper'

RSpec.describe 'AwsUtils::BatchDetectSentiment', type: :service do
  describe '#initialize' do
    let(:text_list) do
      [
        'text1',
        'text2',
        'text3',
      ]
    end

    it 'initiates a new object with attributes' do
      aws_util = AwsUtils::BatchDetectSentiment.new(text_list)

      expect(aws_util.text_list).to match_array(text_list)
    end
  end

  describe '#call' do
    let(:aws_util) { AwsUtils::BatchDetectSentiment.new([]) }

    xit 'fetches sentiments' do
    end
  end
end