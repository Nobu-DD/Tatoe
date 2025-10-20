class AddColumnToTopics < ActiveRecord::Migration[7.2]
  def change
    add_column :topics, :answers_count, :integer
    add_column :topics, :likes_count, :integer
  end
end
