class Comment < ApplicationRecord
  include PublishedAtSettable

  validates :body, presence: true, length: { maximum: 100 }
  validates :published_at, presence: true

  has_many :likes, as: :likeable
  belongs_to :user
  belongs_to :answer, counter_cache: :comments_count
end
