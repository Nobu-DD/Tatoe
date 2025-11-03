class AssignUniqeToGenre < ActiveRecord::Migration[7.2]
  def change
    change_column :genres, :name, :string, null: false
    add_index :genres, :name, unique: true
  end
end
