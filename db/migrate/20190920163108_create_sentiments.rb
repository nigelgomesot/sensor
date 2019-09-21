class CreateSentiments < ActiveRecord::Migration[5.2]
  def change
    create_table :sentiments do |t|
      t.text :level
      t.float :mixed_score
      t.float :negative_score
      t.float :neutral_score
      t.float :positive_score
      t.references :message, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :sentiments, :level
  end
end
