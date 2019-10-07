class SentimentDetector
  MESSAGES_MAX_LENGTH = 25

  attr_reader :messages, :sentiments, :aws_client

  def initialize(messages)
    @messages = messages
    @sentiments = []
    set_aws_client
  end

  def execute!
    detect_sentiments!
    create_sentiments
  end

  private

    def detect_sentiments!
      if messages.empty? || messages.length > MESSAGES_MAX_LENGTH
        error_message = "number of messages expected: 1 to #{MESSAGES_MAX_LENGTH}"
        Rails.logger.fatal(error_message)

        raise error_message
      end

      text_list = messages.map(&:text)
      response = aws_client.batch_detect_sentiment(text_list)

      if response['error_list'].present?
        response['error_list'].each do |error|
          message = @messages[(error['index'])]
          message_id = message.id
          code = error['error_code']
          message = error['error_message']
          error_message = "detect sentiment error for message_id: #{message_id}, code: #{code}, message: #{message}"
          Rails.logger.error(error_message)
        end

        raise "AWS error"
      end

      @sentiments = response['result_list']
      if @sentiments && @sentiments.empty?
        message = "result is empty"
        Rails.logger.fatal(message)

        raise message
      end
    end

    def create_sentiments
      @sentiments.each do |sentiment_detail|
        begin
          message = @messages[(sentiment_detail['index'])]
          create_sentiment!(sentiment_detail, message)
        rescue => err
          error_message = "create sentiment error: message##{message.id}, #{err.message}"

          Rails.logger.error(error_message)
        end
      end
    end

    def create_sentiment!(sentiment_detail, message)
      Sentiment.create! do |s|
        s.message = message
        s.user = message.user
        s.level = sentiment_detail['sentiment'].downcase
        s.mixed_score = sentiment_detail['sentiment_score']['mixed']
        s.negative_score = sentiment_detail['sentiment_score']['negative']
        s.neutral_score = sentiment_detail['sentiment_score']['neutral']
        s.positive_score = sentiment_detail['sentiment_score']['positive']
      end
    end

    def set_aws_client
      comprehend_client = Aws::Comprehend::Client.new
      @aws_client = Clients::Aws.new(comprehend_client)
    end
end

__END__

sd = SentimentDetector.new(Message.all)
sd.execute!
