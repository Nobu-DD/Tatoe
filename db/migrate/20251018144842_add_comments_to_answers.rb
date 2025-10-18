class AddCommentsToAnswers < ActiveRecord::Migration[7.2]
  def change
    add_column :answers, :comments_count, :integer
  end
end
