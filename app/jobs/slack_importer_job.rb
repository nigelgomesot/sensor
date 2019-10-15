class SlackImporterJob < ApplicationJob
  queue_as :default

  def perform(*args)
    importer = SlackImporter.new(*args)

    importer.execute!
  end
end

__END__

SlackImporterJob.perform_now({ channel_id: 'CNGCN4PC0', from_datetime: '2010-01-01' })
