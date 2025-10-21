class AddCounterCulture < ActiveRecord::Migration[7.2]
  def change
    change_column_default :topics, :answers_count, 0
    change_column_null :topics, :answers_count, true
    change_column_default :topics, :likes_count, 0
    change_column_null :topics, :likes_count, true

    change_column_default :answers, :comments_count, 0
    change_column_null :answers, :comments_count, true
    change_column_default :answers, :reactions_count, 0
    change_column_null :answers, :reactions_count, true

    add_column :answers, :empathy_count, :integer, null: false, default: 0
    add_column :answers, :consent_count, :integer, null: false, default: 0
    add_column :answers, :smile_count, :integer, null: false, default: 0
  end
end
