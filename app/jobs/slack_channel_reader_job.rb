class SlackChannelReaderJob < ApplicationJob
  queue_as :default
  SLACK_CHANNEL = 'CNGCN4PC0'

  def perform(from_datetime = nil, upto_datetime = nil)
    from_timestamp = (from_datetime || Time.current.beginning_of_day).to_i
    upto_timestamp = (upto_datetime || Time.current.end_of_day).to_i

    reader = SlackUtils::GetConversationsHistory.new(
      SLACK_CHANNEL,
      from_timestamp,
      upto_timestamp)

    reader.call
  end
end

__END__

 SlackChannelReaderJob.perform_now