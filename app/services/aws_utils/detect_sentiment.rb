module AwsUtils
  class DetectSentiment

    def initialize(text)
      @text = text
    end

    def call
      comprehend = Aws::Comprehend::Client.new

      response = comprehend.detect_sentiment({
        language_code: "en",
        text: @text,
      })
    end
  end
end

__END__

data = "why is this system so complicated to understand?"

response = AwsUtils::DetectSentiment.new(data).call
response.sentiment
