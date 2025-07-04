class Topic < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 255 }
  validates :published_at, presence: true

  has_many :hints, dependent: :destroy
  has_many :answers, dependent: :destroy
  belongs_to :user
end
