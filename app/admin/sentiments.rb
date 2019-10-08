ActiveAdmin.register Sentiment do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :level, :mixed_score, :negative_score, :neutral_score, :positive_score, :message_id, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:level, :mixed_score, :negative_score, :neutral_score, :positive_score, :message_id, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  collection_action :import, method: :post do
    # TODO: idempotency
    from_datetime = Time.current.beginning_of_day - 50.day
    message_ids = Message.all.where("created_at >= ?", from_datetime).limit(25).pluck(:id)
    SentimentDetectorJob.perform_now(message_ids)

    redirect_to collection_path, notice: "Sentiments analysis started successfully!"
  end

  action_item :view, only: :index do
    link_to 'Anaylze Sentiments', import_admin_sentiments_path, method: :post
  end
end
