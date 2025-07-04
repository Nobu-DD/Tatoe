class CreateAnswerReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :answer_reactions do |t|
      t.belongs_to :user
      t.belongs_to :answer
      t.belongs_to :reaction
      t.datetime :published_at, null: false
      t.timestamps
    end
  end
end
