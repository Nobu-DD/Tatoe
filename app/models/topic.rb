class Topic < ApplicationRecord
  include PublishedAtSettable
  before_save :assign_genres

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

  attr_accessor :genre_names
  accepts_nested_attributes_for :hints, allow_destroy: true

  scope :with_active_pickup, -> { joins(:pickups).merge(Pickup.active) }
  scope :ransack_search, -> (query) {
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

  # 編集ページにgenre_names
  def edit_genre_names_form
    genres.pluck(:name).join(",")
  end

  private

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[title description published_at] + _ransackers.keys
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user genres hints]
  end

  def self.ransackable_scopes(auth_object = nil)
    %w[keywords]
  end

  # ジャンル新規登録
  def assign_genres
    if genre_names.blank?
      self.genres = []
      return
    end

    names = genre_names.split(/[[:space:],、\/]|　+/).reject(&:blank?).uniq
    self.genres = names.map { |name| Genre.find_or_create_by(name: name) }
  end

  def genre_names_length
    return if genre_names.blank?
    genre_names.split(/[[:space:],、\/]|　+/).reject(&:blank?).uniq.each do |genre|
      if genre.strip.length > 15
        errors.add(:genres, :too_long, count: 15)
      end
    end
  end
end
