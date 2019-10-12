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
end
