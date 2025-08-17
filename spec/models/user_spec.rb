require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    context 'ユーザーを保存させる時' do
      it '全ての値が入力されている場合(avatar以外)' do
        user = build(:user)
        expect(user).to be_valid
      end
    end
    context 'ユーザーを保存させない時' do
      it 'ユーザー名が未入力' do
      end
      it 'メールアドレスが未入力' do
      end
      it 'パスワードが未入力' do
      end
      it '確認用パスワードが未入力' do
      end
      it 'パスワードと確認用パスワードが不一致' do
      end
    end
  end
end
