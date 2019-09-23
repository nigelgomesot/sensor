class SlackChannelReaderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    reader = SlackChannelReader.new(*args)

    reader.execute!
  end
end

__END__

SlackChannelReaderJob.perform_now('CNGCN4PC0', from_datetime: Time.current - 50.day)
