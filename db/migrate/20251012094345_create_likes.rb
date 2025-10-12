class CreateLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :likes do |t|
      t.belongs_to :user
      t.belongs_to :likeable, polymorphic: true
      t.timestamps
    end
  end
end
