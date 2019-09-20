class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :code
      t.string :provider

      t.timestamps
    end
    add_index :users, :code
  end
end
