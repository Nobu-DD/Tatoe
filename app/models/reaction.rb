class Reaction < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }

  enum name: { agree: 1 }

  has_many :answer_reactions, dependent: :destroy
end
