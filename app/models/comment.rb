class Comment < ApplicationRecord
  include PublishedAtSettable

  validates :body, presence: true, length: { maximum: 100 }
  validates :published_at, presence: true

  belongs_to :user
  belongs_to :answer

end
