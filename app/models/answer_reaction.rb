class AnswerReaction < ApplicationRecord
  include PublishedAtSettable

  validates :published_at, presence: true
  validates_uniqueness_of :user_id, scope: [ :answer_id, :reaction_id ]

  belongs_to :user
  belongs_to :answer
  belongs_to :reaction

  counter_culture :answer, column_name: "reactions_count"
  counter_culture :answer,
    column_name: proc { |model|
      case model.reaction_id
      when 1
        "empathy_count"
      when 2
        "consent_count"
      when 3
        "smile_count"
      end
    },
    column_names: {
      [ "answer_reactions.reaction_id = ?", 1 ] => "empathy_count",
      [ "answer_reactions.reaction_id = ?", 2 ] => "consent_count",
      [ "answer_reactions.reaction_id = ?", 3 ] => "smile_count"
    }

    private

    # Ransack
    def self.ransackable_attributes(auth_object = nil)
      %w[answer_id reaction_id published_at]
    end
end
