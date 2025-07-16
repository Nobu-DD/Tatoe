require 'rails_helper'

RSpec.describe User, type: :model do
  describe '新規登録時のバリデーションチェック' do
    it 'ユーザー名、メールアドレス、パスワード、確認用パスワードが入力かつバリデーションが通るか' do
      user = build(:user)
      expect(user).to be_valid
    end
  end
end
