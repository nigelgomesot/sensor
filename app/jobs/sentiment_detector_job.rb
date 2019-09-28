class SentimentDetectorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    reader = SentimentDetector.new(*args)

    reader.execute!
  end
end

__END__

SentimentDetectorJob.perform_now(from_datetime: Time.current - 50.day)
