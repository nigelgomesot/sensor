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

  collection_action :new_detection, method: :get do
    render "new_detection"
  end

  collection_action :create_detection, method: :post do
    from_datetime = params[:detection][:from_datetime]
    upto_datetime = params[:detection][:upto_datetime]

    message_ids = Message.all
      .includes(:sentiment)
      .where("messages.sent_at >= ?", from_datetime)
      .where("messages.sent_at <= ?", upto_datetime)
      .where("sentiments.id is NULL")
      .limit(SentimentDetector::MESSAGES_MAX_LENGTH)
      .pluck("messages.id")

    begin
      SentimentDetectorJob.perform_now(message_ids)
      redirect_to collection_path, notice: "Sentiment detection started"
    rescue => err
      redirect_to collection_path, alert: "Sentiment detection failed: #{err.message}"
    end
  end

  action_item :view, only: :index do
    link_to 'Detect Sentiments', new_detection_admin_sentiments_path
  end
end
