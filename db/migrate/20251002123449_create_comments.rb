class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :answer
      t.string :body
      t.datetime :published_at
      t.timestamps
    end

    add_index :comments, [ :user_id, :answer_id]
  end
end
