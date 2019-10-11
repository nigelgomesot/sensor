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
    SlackImporterJob.perform_now(params[:import].to_h)

    redirect_to collection_path, notice: "Messages import started successfully!"
  end

  action_item :view, only: :index do
    link_to 'Import from Slack', new_import_admin_messages_path
  end
end
