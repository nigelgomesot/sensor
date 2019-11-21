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

  actions :index, :show, :destroy

  filter :sent_at, label: 'Sent'
  filter :entities_category, as: :select, collection: Entity.categories, label: 'Category'
  filter :entities_text_cont, label: 'Category text'
  filter :sentiment_level, as: :check_boxes, collection: Sentiment.levels, label: 'Sentiment'
  filter :text

  index do
    selectable_column
    id_column
    column :sent_at
    column :sentiment do |message|
      status_tag message.sentiment&.level, { class: "level_#{message.sentiment&.level}"}
    end
    column :entities do |message|
      message.entities&.count
    end
    column :text
    actions
  end

  show do
    columns do
      column do
        panel "Message Details" do
          attributes_table_for message do
            row :text
            row :sent_at
            row :sentiment do |message|
              status_tag message.sentiment&.level, { class: "level_#{message.sentiment&.level}"}
            end
            row :created_at
            row :updated_at
          end
        end
      end

      column do
        panel "Entities" do
          table_for message.entities.order(score: :desc) do
            column :category do |entity|
              status_tag entity.category, { class: "category"}
            end
            column :text
          end
        end
      end
    end
  end

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
