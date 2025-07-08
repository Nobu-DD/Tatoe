class CreateMyGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :my_genres do |t|
      t.belongs_to :user
      t.belongs_to :genre
      t.timestamps
    end
    add_index :my_genres, [ :user_id, :genre_id ], unique: :true
  end
end
