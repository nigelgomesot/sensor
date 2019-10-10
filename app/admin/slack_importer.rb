ActiveAdmin.register_page "SlackImporter" do

  page_action :new, method: :get do
    render partial: "new"
  end

  page_action :create, method: :post do
    slackimporter_params = params[:slackimporter]
    channel = slackimporter_params[:channel]
    from_datetime = slackimporter_params[:from_datetime]
    upto_datetime = slackimporter_params[:upto_datetime]

    SlackImporterJob.perform_now(channel, from_datetime: from_datetime)
    redirect_to admin_messages_path, notice: "Slack import started"
  end
end
