class SlackChannelReaderJob < ApplicationJob
  queue_as :default

  def perform(from_datetime = nil, upto_datetime = nil)
    reader = SlackChannelReader.new(from_datetime, upto_datetime)

    reader.execute!
  end
end

__END__

SlackChannelReaderJob.perform_now(Time.current - 5.day)
