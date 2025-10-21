class AnswerReaction < ApplicationRecord
  include PublishedAtSettable

  validates :published_at, presence: true
  validates_uniqueness_of :user_id, scope: [ :answer_id, :reaction_id ]

  belongs_to :user
  belongs_to :answer
  belongs_to :reaction
  counter_culture :answer,
    with_associations: [:reaction],
    column_name: "reactions_count",
    column_names: {
      ["answer_reactions.name = ?", 1] => "empathy_count",
      ["answer_reactions.name = ?", 2] => "consent_count",
      ["answer_reactions.name = ?", 3] => "smile_count"
    }
end
