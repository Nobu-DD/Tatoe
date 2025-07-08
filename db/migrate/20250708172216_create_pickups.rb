class CreatePickups < ActiveRecord::Migration[7.2]
  def change
    create_table :pickups do |t|
      t.belongs_to :topic
      t.datetime :start_at, null: false
      t.datetime :end_at
      t.timestamps
    end
    add_index :pickups, [ :start_at, :end_at ]
  end
end
