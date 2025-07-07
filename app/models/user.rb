class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 10 }

  has_many :topics, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :my_genres, dependent: :destroy
  has_many :genres, through: :my_genres
  has_many :answer_reactions, dependent: :destroy
  has_many :reactions, through: :answer_reactions

end
