class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :text
      t.string :provider_message_uid
      t.datetime :sent_at
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :messages, :provider_message_uid
  end
end
