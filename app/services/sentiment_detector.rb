class SentimentDetector
  def initialize(from_datetime: nil, upto_datetime: nil)
    @from_datetime = from_datetime || Time.current.beginning_of_day
    @upto_datetime = upto_datetime || Time.current
    @messages = set_messages
    @aws_client = set_aws_client
  end

  def execute!
    get_sentiments!
  end

  private

    def get_sentiments!
      @messages.find_in_batches(batch_size: 25) do |message_batch|
        # TODO: fetch sentiments and map to messages in the `batch`
        message_array = message_batch.pluck(:id, :text)
        text_list = message_array.collect { |_, text| text }

        response = @aws_client.batch_detect_sentiment(text_list)

        if response['error_list'].present?
          response['error_list'].each do |error|
            message = message_batch[(error['index'])]
            message_id = message.id
            code = error['error_code']
            message = ['error_message']
            Rails.logger.error("message_id: #{message_id} code: #{code}, message: #{message}")
          end

          raise "AWS error"
        end

        sentiments = response['result_list']
        if sentiments && sentiments.empty?
          message = "result is empty"
          Rails.logger.error(message)
          raise message
        end
        create_sentiments!(sentiments, message_batch)
      end
    end

    def create_sentiments!(sentiments, message_batch)
      sentiments.each do |sentiment|
        message = message_batch[(sentiment['index'])]
        sentiment_details = sentiment

        Sentiment.create! do |s|
          s.message = message
          s.user = message.user
          s.level = sentiment_details['sentiment'].downcase
          s.mixed_score = sentiment_details['sentiment_score']['mixed']
          s.negative_score = sentiment_details['sentiment_score']['negative']
          s.neutral_score = sentiment_details['sentiment_score']['neutral']
          s.positive_score = sentiment_details['sentiment_score']['positive']
        end
      end
    end

    def set_messages
      # TODO: fetch where sentiment is nil
      @messages = Message.all
        .where('created_at >= ?', @from_datetime)
        .where('created_at <= ?', @upto_datetime)
    end

    def set_aws_client
      comprehend_client = Aws::Comprehend::Client.new
      Clients::Aws.new(comprehend_client)
    end
end

__END__

sd = SentimentDetector.new(from_datetime: Time.current - 1.year)
sd.execute!
