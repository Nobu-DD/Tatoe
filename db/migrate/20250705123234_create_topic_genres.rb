class CreateTopicGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :topic_genres do |t|
      t.belongs_to :topic
      t.belongs_to :genre
      t.timestamps
    end
  end
end
