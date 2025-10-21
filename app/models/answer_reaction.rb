class AnswerReaction < ApplicationRecord
  include PublishedAtSettable

  validates :published_at, presence: true
  validates_uniqueness_of :user_id, scope: [ :answer_id, :reaction_id ]

  belongs_to :user
  belongs_to :answer, counter_cache: :reactions_count
  belongs_to :reaction
end
