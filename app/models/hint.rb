class Hint < ApplicationRecord
  validates :body, presence: true, length: { maximum: 30 }

  belongs_to :topic
end
