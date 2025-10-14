class Genre < ApplicationRecord
  validates :name, presence: true, length: { maximum: 15 }

  has_many :my_genres, dependent: :destroy
  has_many :users, through: :my_genres
  has_many :topic_genres, dependent: :destroy
  has_many :topics, through: :topic_genres

  private

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[name] + _ransackers.keys
  end
end
