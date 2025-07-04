class Topic < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 255 }
  validates :published_at, presence: true

  belongs_to :user
end
