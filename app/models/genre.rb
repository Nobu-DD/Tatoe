class Genre < ApplicationRecord
  has_many :my_genres, dependent: :destroy
  has_many :users, through: :my_genres
end
