require 'rails_helper'

RSpec.describe "UsersSession", type: :system do
  describe "newアクション" do
    context "正常系" do
      it "ログイン画面に遷移する" do
      end
    end
  end
  describe "createアクション" do
    context "正常系" do
      it "メールアドレス、パスワードを入れると、ログインが成功する" do
      end
    end
    context "異常系" do
      it "メールアドレスが「未入力」または「違っている」" do
      end
      it "パスワードが「未入力」または「違っている」" do
      end
    end
  end
  describe "destroyアクション" do
    context "正常系" do
      it "ログアウトボタンを押すとログアウト出来る" do
      end
    end
  end
end
