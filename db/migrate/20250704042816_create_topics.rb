class CreateTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :topics do |t|
      t.belongs_to :user
      t.text :title,            null: false
      t.text :description
      t.datetime :published_at, null: false

      t.timestamps
    end
  end
end
