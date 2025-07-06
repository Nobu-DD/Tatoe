class CreateHints < ActiveRecord::Migration[7.2]
  def change
    create_table :hints do |t|
      t.belongs_to :topic
      t.text :body, null: false, default: ""

      t.timestamps
    end
  end
end
