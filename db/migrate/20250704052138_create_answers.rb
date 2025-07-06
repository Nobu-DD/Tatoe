class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.belongs_to :user
      t.belongs_to :topic
      t.text :body, null: false
      t.text :reason
      t.datetime :published_at, null: false
      t.timestamps
    end
  end
end
