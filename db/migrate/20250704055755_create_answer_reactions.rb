class CreateAnswerReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :answer_reactions do |t|
      t.belongs_to :user
      t.belongs_to :answer
      t.belongs_to :reaction
      t.datetime :published_at, null: false
      t.timestamps
    end
    add_index :answer_reactions, [ :user_id, :answer_id, :reaction_id ], unique: :true
  end
end
