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
  end
end

__END__

data = [
  "why is this system so complicated to understand?",
  "this system made my day",
]

comprehend_client = ::Aws::Comprehend::Client.new

client = Clients::Aws.new(comprehend_client)
response = client.batch_detect_sentiment(data)
response.result_list.collect {|x| [x.index, x.sentiment]}