class EntityDetectorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    reader = EntityDetector.new(*args)

    reader.execute!
  end
end

__END__

EntityDetectorJob.perform_now(Message.order(created_at: :desc).limit(1).pluck(:id))
