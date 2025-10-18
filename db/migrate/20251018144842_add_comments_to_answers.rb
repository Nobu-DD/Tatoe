class AddCommentsToAnswers < ActiveRecord::Migration[7.2]
  def change
    add_column :answers, :comments_count, :integer
    add_column :answers, :reactions_count, :integer
  end
end
