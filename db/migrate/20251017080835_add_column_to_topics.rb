class AddColumnToTopics < ActiveRecord::Migration[7.2]
  def change
    add_column :topics, :answers_count, :integer
  end
end
