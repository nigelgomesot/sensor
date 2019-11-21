ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :provider, :provider_user_uid
  #
  # or
  #
  # permit_params do
  #   permitted = [:provider, :provider_user_uid]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  actions :index, :show, :destroy

  filter :provider, as: :select, collection: User.providers
  filter :provider_user_uid

  show do
    columns do
      column do
        panel "User Details" do
          attributes_table_for user do
            row :provider
            row :provider_user_uid
            row :created_at
            row :updated_at
          end
        end
      end

      column do
        panel "Recent Messages" do
          table_for user.messages.order(sent_at: :desc).limit(10) do
            column :sent_at
            column :sentiment do |message|
              status_tag message.sentiment&.level, { class: "level_#{message.sentiment&.level}"}
            end
            column :text
          end
        end
      end
    end
  end

end
