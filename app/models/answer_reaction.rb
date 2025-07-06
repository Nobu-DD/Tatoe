class AnswerReaction < ApplicationRecord
  include PublishedAtSettable

  validates :published_at, presence: true

  belongs_to :user
  belongs_to :answer
  belongs_to :reaction
end
