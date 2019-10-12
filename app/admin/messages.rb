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

  collection_action :new_import, method: :get do
    render "new_import"
  end

  collection_action :create_import, method: :post do
    from_datetime = params[:import][:from_datetime] + " 00:00:00"
    upto_datetime = params[:import][:upto_datetime] + " 23:59:59"

    import_params = {
      channel_id: params[:import][:channel_id],
      from_datetime: from_datetime,
      upto_datetime: upto_datetime,
    }
    SlackImporterJob.perform_now(import_params)

    redirect_to collection_path, notice: "Messages import started successfully!"
  end

  action_item :view, only: :index do
    link_to 'Import from Slack', new_import_admin_messages_path
  end
end
