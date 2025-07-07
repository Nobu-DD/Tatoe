class Reaction < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }

  enum name: { agree: 1 }

  scope :topic_reactions, ->(topic) { joins(answer_reactions: :answer).where(answers: { topic_id: topic.id }).distinct }

  has_many :answer_reactions, dependent: :destroy
end
