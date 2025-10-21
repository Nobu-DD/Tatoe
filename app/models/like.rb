class Like < ApplicationRecord
  validates_uniqueness_of :user_id, scope: [ :likeable_id, :likeable_type ]

  belongs_to :user
  belongs_to :likeable, polymorphic: true
  counter_culture :likeable, column_name: "likes_count"
end
