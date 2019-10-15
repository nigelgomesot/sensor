class SentimentDetectorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    reader = SentimentDetector.new(*args)

    reader.execute!
  end
end

__END__

SentimentDetectorJob.perform_now(Message.order(created_at: :desc).limit(1).pluck(:id))
