class User < ApplicationRecord
  before_save :assign_genres
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :name, presence: true, length: { maximum: 10 }

  has_many :topics, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :my_genres, dependent: :destroy
  has_many :genres, through: :my_genres
  has_many :answer_reactions, dependent: :destroy
  has_many :reactions, through: :answer_reactions
  has_many :likes, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  attr_accessor :genre_names

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # ユーザーが存在しない場合、新規作成する処理。
    # unless user
    #     user = User.create(name: data['name'],
    #        email: data['email'],
    #        password: Devise.friendly_token[0,20]
    #     )
    # end
    user
end

  def own?(object)
    id == object.user_id
  end

  def not_own?(object)
    id != object.user_id
  end

  def answer_reaction(answer, reaction)
    answer_reactions.find_or_create_by(answer: answer, reaction: reaction)
  end

  def unanswer_reaction(answer, reaction)
    answer_reactions.find_by(answer: answer, reaction: reaction)&.destroy
  end

  def answer_reaction?(answer, reaction)
    answer_reactions.include?(answer: answer, reaction: reaction)
  end

  def edit_genre_names_form
    genres.pluck(:name).join(",")
  end

  # ジャンル新規登録
  def assign_genres
    # userインスタンスのgenre_names属性に値が格納されていない場合、早期リターンを返す。(ここから改善予定)
    if genre_names.blank?
      self.genres = []
      return
    end

    names = genre_names.split(/[[:space:],、\/]|　+/).reject(&:blank?).uniq
    self.genres = names.map { |name| Genre.find_or_create_by(name: name) }
  end

  private

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[name] + _ransackers.keys
  end
end
