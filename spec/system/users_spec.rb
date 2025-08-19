require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "newアクション" do
    context "正常系" do
      it "新規登録画面に遷移する" do

      end
    end
  end
  describe "createアクション" do
    context "正常系" do
      it "入力必須のフォームに値を入れて登録出来る" do

      end
    end
    context "異常系" do
      it "ユーザー名を入れていない時" do

      end
      it "メールアドレスを入れていない時" do

      end
      it "パスワードを入れていない時" do

      end
      it "パスワードと確認用パスワードが一致しない時" do

      end
    end
  end
end