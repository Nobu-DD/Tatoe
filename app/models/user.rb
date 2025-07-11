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

  def own?(object)
    id == object.user_id
  end

  def answer_reaction(answer, reaction)
    answer_reactions.find_or_create_by(answer: answer, reaction: reaction)
  end

  def unanswer_reaction(answer, reaction)
    answer_reactions.find_by(answer: answer, reaction: reaction)&.destroy
  end

  def answer_reaction?(answer, reaction)
    # 間違っている可能性有り。マイページ追加時に確認
    answer_reactions.include?(answer: answer, reaction: reaction)
  end
end
