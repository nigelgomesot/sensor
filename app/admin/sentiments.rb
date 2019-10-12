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

  actions :index, :show

  collection_action :new_detection, method: :get do
    render "new_detection"
  end

  collection_action :create_detection, method: :post do
    from_datetime = params[:detection][:from_datetime] + " 00:00:00"
    upto_datetime = params[:detection][:upto_datetime] + " 23:59:59"

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


  index do
    id_column
    column :sent_at
    column :level do |sentiment|
      status_tag sentiment.level, { class: "level_#{sentiment.level}"}
    end
    column :text
    actions
  end

  show do
    attributes_table do
      row :sent_at
      row :level do |sentiment|
        status_tag sentiment.level, { class: "level_#{sentiment.level}"}
      end
      row :text
      row :positive_score
      row :neutral_score
      row :negative_score
      row :mixed_score
      row :user do |sentiment|
        link_to 'User', admin_user_path(sentiment.user)
      end
    end
  end

  filter :level, as: :select, collection: Sentiment.levels
  filter :positive_score
  filter :neutral_score
  filter :negative_score
  filter :mixed_score
  filter :message_sent_at, as: :date_range
  filter :message_text, as: :string
end
