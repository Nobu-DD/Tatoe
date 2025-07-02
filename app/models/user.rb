class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :topics, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :my_genres, dependent: :destroy
  has_many :genres, through: :my_genres
end
