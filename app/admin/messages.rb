ActiveAdmin.register Message do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :text, :provider_message_uid, :sent_at, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:text, :provider_message_uid, :sent_at, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  collection_action :import, method: :post do
    from_datetime = Time.current.beginning_of_day - 50.day
    SlackImporterJob.perform_now('CNGCN4PC0', from_datetime: from_datetime)

    redirect_to collection_path, notice: "Messages import started successfully!"
  end

  action_item :view, only: :index do
    link_to 'Import from Slack', admin_slackimporter_new_path
  end
end
