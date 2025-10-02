class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 50 }
  validates :published_at, presence: true

  belongs_to :user
  belongs_to :answer
end
