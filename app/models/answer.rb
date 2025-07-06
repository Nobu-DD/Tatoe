class Answer < ApplicationRecord
  include PublishedAtSettable

  validates :body, presence: true, length: { maximum: 30 }
  validates :reason, length: { maximum: 255 }
  validates :published_at, presence: true

  belongs_to :user
  belongs_to :topic
end
