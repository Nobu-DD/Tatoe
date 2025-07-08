class MyGenre < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  validates_uniqueness_of :user_id, scope: :genre_id
end
