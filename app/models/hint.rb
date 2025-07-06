class Hint < ApplicationRecord
  validates :body, length: { maximum: 50 }

  belongs_to :topic
end
