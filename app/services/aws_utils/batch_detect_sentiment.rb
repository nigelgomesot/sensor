module AwsUtils
class BatchDetectSentiment

    def initialize(text_list)
      @text_list = text_list
    end

    def call
      comprehend = Aws::Comprehend::Client.new

      response = comprehend.batch_detect_sentiment({
        language_code: "en",
        text_list: @text_list
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

response = AwsUtils::BatchDetectSentiment.new(data).call
response.result_list.collect {|x| [x.index, x.sentiment]}
