class AddCounterCulture < ActiveRecord::Migration[7.2]
  def change
    change_column :topics, :answers_count, :integer, null: false, default: 0
    change_column :topics, :likes_count, :integer, null: false, default: 0

    change_column :answers, :comments_count, :integer, null: false, default: 0
    change_column :answers, :reactions_count, :integer, null: false, default: 0

    add_column :answers, :empathy_count, :integer, null: false, default: 0
    add_column :answers, :consent_count, :integer, null: false, default: 0
    add_column :answers, :smile_count, :integer, null: false, default: 0
  end
end
