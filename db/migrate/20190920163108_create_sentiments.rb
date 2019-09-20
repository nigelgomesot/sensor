class CreateSentiments < ActiveRecord::Migration[5.2]
  def change
    create_table :sentiments do |t|
      t.text :value
      t.float :mixed_score
      t.float :negative_score
      t.float :neutral_score
      t.float :positive_score
      t.references :comment, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :sentiments, :value
  end
end
