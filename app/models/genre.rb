class Genre < ApplicationRecord
  has_many :my_genres, dependent: :destroy
  has_many :users, through: :my_genres
  has_many :topic_genres, dependent: :destroy
  has_many :topics, through: :topic_genres
end
