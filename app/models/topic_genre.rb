class TopicGenre < ApplicationRecord
  belongs_to :genre
  belongs_to :topic

  validates_uniqueness_of :genre_id, scope: :topic_id
end
