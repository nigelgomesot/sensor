class SlackReader
  LIMIT_PER_REQUEST = 100

  attr_reader :channel, :oldest_timestamp, :latest_timestamp, :messages, :slack_client

  def initialize(channel_id:, from_datetime:, upto_datetime:)
    @channel = channel_id
    @oldest_timestamp = get_timestamp(from_datetime)
    @latest_timestamp = get_timestamp(upto_datetime)
    @slack_client = get_slack_client
    @messages = []
  end

  def execute!
    read!
  end

  private

    def get_timestamp(datetime_str)
      DateTime.parse(datetime_str).to_i
    end

    def get_slack_client
      Slack::Web::Client.new
    end

    def read!
      args = {
        channel:          @channel,
        oldest_timestamp: @oldest_timestamp,
        latest_timestamp: @latest_timestamp,
        limit:            LIMIT_PER_REQUEST
      }

      @slack_client.conversations_history(args) do |response|
        @messages.concat(response.messages)
      end
    end
end

__END__

args = {
  channel_id: 'CNGCN4PC0',
  from_datetime: '2010-01-01',
  upto_datetime: '2019-10-15'
}
sr = SlackReader.new(args)
sr.execute!
sr.messages.inspect
