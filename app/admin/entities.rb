ActiveAdmin.register Entity do

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

  filter :category, as: :select, collection: Entity.categories
  filter :score
  filter :message_sent_at, as: :date_range
  filter :message_text, as: :string

  index do
    id_column
    column :sent_at
    column :category do |entity|
      status_tag entity.category, { class: "category"}
    end
    column :text
    actions
  end

  show do
    attributes_table do
      row :sent_at
      row :category do |entity|
        status_tag entity.category, { class: "category"}
      end
      row :text
      row :message_text
      row :score
      row :message
      row :user do |entity|
        link_to 'User', admin_user_path(entity.user)
      end
      row :created_at
      row :updated_at
    end
  end

  collection_action :new_detection, method: :get do
    render "new_detection"
  end

  collection_action :create_detection, method: :post do
    from_datetime = params[:detection][:from_datetime] + " 00:00:00"
    upto_datetime = params[:detection][:upto_datetime] + " 23:59:59"

    message_ids = Message.all
      .includes(:entities)
      .where("messages.sent_at >= ?", from_datetime)
      .where("messages.sent_at <= ?", upto_datetime)
      .where("entities.id is NULL")
      .limit(EntityDetector::MESSAGES_MAX_LENGTH)
      .pluck("messages.id")

    begin
      EntityDetectorJob.perform_now(message_ids)
      redirect_to collection_path, notice: "Entity detection started"
    rescue => err
      redirect_to collection_path, alert: "Entity detection failed: #{err.message}"
    end
  end

  action_item :view, only: :index do
    link_to 'Detect Entities', new_detection_admin_entities_path
  end
end
