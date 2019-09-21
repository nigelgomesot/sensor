class SlackChannelReaderJob < ApplicationJob
  queue_as :default

  def perform(from_datetime = nil, upto_datetime = nil)
    SlackChannelReader.call(from_datetime, upto_datetime)
  end
end

__END__

 SlackChannelReaderJob.perform_now(Time.current - 5.day)