class SentimentDetector
  def initialize(from_datetime: nil, upto_datetime: nil)
    @from_datetime = from_datetime || Time.current.beginning_of_day
    @upto_datetime = upto_datetime || Time.current
  end

  def execute!
    get_sentiments!
    create_sentiments
  end

  private

    def get_sentiments!
      messages = get_messages
      aws_client = get_aws_client

      messages.in_batches(batch_size: 25) do |batch|
        # TODO: fetch sentiments and map to messages in the `batch`
      end
    end

    def create_sentiments!

    end

    def get_messages
      # TODO: fetch where sentiment is nil
      Message.all
        .where('created_at >= ?', @from_datetime)
        .where('created_at <= ?', @upto_datetime)
    end

    def get_aws_client
      comprehend_client = Aws::Comprehend::Client.new
      client = Clients::Aws.new(comprehend_client)
    end
end