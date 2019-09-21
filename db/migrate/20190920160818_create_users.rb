class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :provider_user_uid

      t.timestamps
    end
    add_index :users, :provider_user_uid
  end
end
