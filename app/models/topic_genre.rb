class TopicGenre < ApplicationRecord
  belongs_to :genre
  belongs_to :topic
end
