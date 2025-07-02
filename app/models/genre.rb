class Genre < ApplicationRecord

  has_many :mygenres, dependent: :destroy
  has_many :users, through: :mygenres
end
