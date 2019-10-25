class SlackWriter

  attr_reader :messages

  def initialize(messages)
    @messages = messages
  end

  def execute
    write
  end

  private

    def write
      @messages.each do |message|
        begin
          user = find_or_create_user!(message)

          find_or_create_message!(user, message)
        rescue => err
          Rails.logger.error("SlackWriter error: #{err.message}, message: #{message}")
        end
      end
    end

    def find_or_create_user!(message_details)
      provider_user_uid = message_details['user']

      attributes = {
        provider_user_uid: provider_user_uid,
        provider: :slack
      }

      User.find_or_create_by!(attributes)
    end

    def find_or_create_message!(user, message_details)
      text = message_details['text']
      provider_message_uid = message_details['client_msg_id']
      sent_at = Time.at(message_details['ts'].to_f)
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