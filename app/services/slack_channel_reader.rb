class SlackChannelReader

  attr_reader :channel, :oldest_timestamp, :latest_timestamp

  def initialize(channel_id, from_datetime: nil, upto_datetime: nil)
    @channel = channel_id
    @oldest_timestamp = (from_datetime || Time.current.beginning_of_day).to_i
    @latest_timestamp = (upto_datetime || Time.current.end_of_day).to_i
    @messages = []
  end

  def execute!
    read_messages!
    create_messages
  end

  private

    def read_messages!
      args = {
        channel:          @channel,
        oldest_timestamp: @oldest_timestamp,
        latest_timestamp: @latest_timestamp,
      }

      slack_client = SlackClient.new
      response = slack_client.get_conversations_history(args)

      if response.code != 200
        raise 'invalid response status'
      end

      parsed_body = JSON.parse(response.body)

      if !(parsed_body['ok'] && parsed_body['ok'] == true)
        raise 'invalid response body'
      end

      @messages = parsed_body['messages']
    end

    def create_messages
      @messages.each do |message|
        begin
          user = find_or_create_user!(message)

          find_or_create_user_message!(user, message)
        rescue => err
          Rails.logger.error("SlackChannelReader error: #{err.message}, message: #{message}")
        end
      end
    end

    def find_or_create_user!(message_hash)
      provider_user_uid = message_hash['user']

      attributes = {
        provider_user_uid: provider_user_uid,
        provider: :slack
      }

      User.find_or_create_by!(attributes)
    end

    def find_or_create_user_message!(user, message_hash)
      text = message_hash['text']
      provider_message_uid = message_hash['client_msg_id']
      sent_at = Time.at(message_hash['ts'].to_f)
      user_id = user.id

      attributes = {
        user_id: user.id,
        provider_message_uid: provider_message_uid
      }

      Message.find_or_create_by!(attributes) do |message|
        message.text = text
        message.sent_at = sent_at
      end
    end
end
