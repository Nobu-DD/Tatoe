class AddOgpImage < ActiveRecord::Migration[7.2]
  def change
    add_column :topics, :ogp_image, :string
    add_column :answers, :ogp_image, :string
  end
end
