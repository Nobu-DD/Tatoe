require 'rails_helper'

RSpec.describe "User", type: :model do
  describe 'バリデーションチェック' do
    before do
      @user = build(:user)
    end
    context 'ユーザーを保存させる時' do
      it '全ての値が入力されている場合(avatar以外)' do
        expect(@user).to be_valid
      end
    end
    context 'ユーザーを保存させない時' do
      it 'ユーザー名が未入力' do
        # ユーザー名が入力されていないuserモデルインスタンスを作成する
        @user[:name] = ""
        # 作成したインスタンスに対してバリデーションエラーになってくれるか検証
        expect(@user).to be_invalid
        # エラーメッセージの内容が「」(ユーザー名が入力されていない)というメッセージがあるか検証
        expect(@user.errors[:name]).to eq([ "を入力してください" ])
      end
      it 'メールアドレスが未入力' do
        # メールアドレスが入力されていないuserモデルインスタンスを作成する
        @user[:email] = ""
        # 作成したインスタンスに対してバリデーションエラーになってくれるか検証
        expect(@user).to be_invalid
        # エラーメッセージの内容が「」であることを検証
        expect(@user.errors[:email]).to eq([ "を入力してください" ])
      end
      it 'パスワードが未入力' do
        # パスワードが入力されていないuserモデルインスタンスを作成する
        @user.password = ""
        # 作成したモデルインスタンスがバリデーションエラーになってくれるか確認
        expect(@user).to be_invalid
        # エラーメッセージの内容が[]であること
        expect(@user.errors[:password]).to eq([ "を入力してください。" ])
      end
      it '確認用パスワードが未入力、またはパスワードと確認用が不一致' do
        # パスワードが入力されていないuserモデルインスタンスを作成する
        @user.password = "password"
        @user.password_confirmation = ""
        # 作成したモデルインスタンスがバリデーションエラーになってくれるか確認
        expect(@user).to be_invalid
        # エラーメッセージの内容が[]であること
        expect(@user.errors[:password_confirmation]).to eq([ "とパスワードの入力が一致しません。" ])
      end
      it 'パスワードと確認用パスワードが不一致' do
        @user.password = "password"
        @user.password_confirmation = "password2"
        expect(@user).to be_invalid
        expect(@user.errors[:password_confirmation]).to eq([ "とパスワードの入力が一致しません。" ])
      end
    end
  end
end
