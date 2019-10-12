class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.references :message, foreign_key: true
      t.references :user, foreign_key: true
      t.string :category
      t.decimal :score
      t.string :text

      t.timestamps
    end
  end
end
