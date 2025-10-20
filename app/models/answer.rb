class Answer < ApplicationRecord
  include PublishedAtSettable

  validates :body, presence: true, length: { maximum: 30 }
  validates :reason, length: { maximum: 255 }
  validates :published_at, presence: true

  has_many :comments, dependent: :destroy
  has_many :answer_reactions
  has_many :reactions, through: :answer_reactions
  belongs_to :user
  belongs_to :topic, counter_cache: :answers_count

  private

    # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[comments_count] + _ransackers.keys
  end
end
