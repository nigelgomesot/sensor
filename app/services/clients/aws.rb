module Clients
  class Aws
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def batch_detect_sentiment(text_list = [])
      raise StandardError.new('text_list is empty') if text_list.empty?

      response = @service.batch_detect_sentiment({
          text_list: text_list,
          language_code: "en",
        })

      response
    end

    def batch_detect_entities(text_list = [])
      raise StandardError.new('text_list is empty') if text_list.empty?

      response = @service.batch_detect_entities({
          text_list: text_list,
          language_code: "en",
        })

      response
    end
  end
end

__END__


comprehend_client = ::Aws::Comprehend::Client.new
client = Clients::Aws.new(comprehend_client)

data = [
  "why is this system so complicated to understand?",
  "this system made my day",
]
response = client.batch_detect_sentiment(data)
response.result_list.collect {|x| [x.index, x.sentiment]}

data = [
  "ticket booked on April 1 2019 for Seattle",
  "the party is in Chicago",
]
response = client.batch_detect_entities(data)
response.result_list.collect {|x| [x.index, x.sentiment]}
