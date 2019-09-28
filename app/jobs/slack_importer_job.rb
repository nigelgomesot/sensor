class SlackImporterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    reader = SlackImporter.new(*args)

    reader.execute!
  end
end

__END__

SlackImporterJob.perform_now('CNGCN4PC0', from_datetime: Time.current - 50.day)
