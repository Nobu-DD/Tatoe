class Topic < ApplicationRecord
  include PublishedAtSettable
  before_save :create_genres
  before_save :add_ogp

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :published_at, presence: true
  validate :genre_names_length

  has_many :hints, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :topic_genres, dependent: :destroy
  has_many :genres, through: :topic_genres
  has_many :pickups, dependent: :destroy
  has_many :likes, as: :likeable
  belongs_to :user
  mount_uploader :ogp_image, AvatarUploader

  attr_accessor :genre_names
  accepts_nested_attributes_for :hints, allow_destroy: true

  scope :with_active_pickup, -> { joins(:pickups).merge(Pickup.active) }
  scope :ransack_search, ->(query) {
    return ransack(query) if query.blank?
    search = {}
    query.each do |key, value|
      next search[key] = value if value.blank? || key.include?("published_at_")
      value = value.split(/[[:space:],、\/]|　+/).reject(&:blank?).uniq
      search[key] = value
      puts search
    end
    ransack(search)
  }

  private

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[title description published_at answers_count likes_count] + _ransackers.keys
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user genres hints]
  end

  # ジャンル新規登録
  def create_genres
    return self.genres = [] if genre_names.blank?

    names = genre_names.uniq
    self.genres = names.map { |name| Genre.find_or_create_by(name: name) }
  end

  def add_ogp
    self.ogp_image = OgpCreatorService.topic_build(self)
  end

  def genre_names_length
    return if genre_names.blank?
    genre_names.uniq.each do |genre|
      if genre.strip.length > 15
        errors.add(:genres, :too_long, count: 15)
      end
    end
  end
end
