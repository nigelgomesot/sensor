require 'rails_helper'

RSpec.describe AwsClient, type: :service do
  let(:service_stub) do
    Aws::Comprehend::Client.new(stub_responses: true)
  end

  describe '#initialize' do
    it 'initializes with a specific AWS service' do
      aws_client = AwsClient.new(service_stub)

      expect(aws_client.service).to eq(service_stub)
    end
  end

  describe '#batch_detect_sentiment' do
    let(:text_list) { ['text'] }
    let(:aws_client) do
      AwsClient.new(service_stub)
    end

    it 'fetches sentiment for a batch' do
      service_stub.stub_responses(
        :batch_detect_sentiment,
        batch_detect_sentiment_stub_response,
      )

      response = aws_client.batch_detect_sentiment(text_list)

      expect(response.to_hash).to eq(batch_detect_sentiment_stub_response)
    end

    it 'raises error if `text_list` is empty' do
      text_list = []

      expect do
        aws_client.batch_detect_sentiment(text_list)
      end.to raise_error(StandardError, 'text_list is empty')
    end

    it 'raises error if AWS SDK throws error' do
      error = StandardError.new('AWS SDK error')

      service_stub.stub_responses(
        :batch_detect_sentiment,
        error,
      )

      expect do
        aws_client.batch_detect_sentiment(text_list)
      end.to raise_error(StandardError, 'AWS SDK error')
    end

    def batch_detect_sentiment_stub_response
      {
        :result_list=>[
          {
            :index=>1,
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
    end
  end
end