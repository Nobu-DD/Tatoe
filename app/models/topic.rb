class Topic < ApplicationRecord
  include PublishedAtSettable
  before_save :assign_genres

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :published_at, presence: true

  has_many :hints, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :topic_genres, dependent: :destroy
  has_many :genres, through: :topic_genres
  has_many :pickups, dependent: :destroy
  belongs_to :user

  attr_accessor :genre_names
  accepts_nested_attributes_for :hints, allow_destroy: true

  scope :with_active_pickup, -> { joins(:pickups).merge(Pickup.active) }

  private

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[title description] + _ransackers.keys
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user genres hints]
  end

  # ジャンル新規登録
  def assign_genres
    return if genre_names.blank?

    names = genre_names.split(/[[:space:],、\/]|　+/).reject(&:blank?).uniq
    self.genres = names.map { |name| Genre.find_or_create_by(name: name) }
  end
end
