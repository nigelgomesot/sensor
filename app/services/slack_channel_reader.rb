class SlackChannelReader
	 SLACK_CHANNEL = 'CNGCN4PC0'

  def self.call(from_datetime = nil, upto_datetime = nil)
    messages = fetch_messages(from_datetime, upto_datetime)

    create_messages(messages)
  end

  def self.fetch_messages(from_datetime, upto_datetime)
    from_timestamp = (from_datetime || Time.current.beginning_of_day).to_i
    upto_timestamp = (upto_datetime || Time.current.end_of_day).to_i

    reader = SlackUtils::GetConversationsHistory.new(
      SLACK_CHANNEL,
      from_timestamp,
      upto_timestamp)

    response = reader.call
    response['messages']
  end

  def self.create_messages(messages)
    messages.each do |message|
      begin
        user = find_or_create_user!(message)

        find_or_create_user_message!(user, message)
      rescue => err
        Rails.logger.error("SlackChannelReader error: #{err.message}, message: #{message}")
      end
    end
  end

  def self.find_or_create_user!(message_hash)
    provider_user_uid = message_hash['user']

    attributes = {
      provider_user_uid: provider_user_uid,
      provider: :slack
    }

    User.find_or_create_by!(attributes)
  end

  def self.find_or_create_user_message!(user, message_hash)
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