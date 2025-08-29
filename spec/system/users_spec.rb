require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "newアクション" do
    context "正常系" do
      it "新規登録画面に遷移する" do
        # パスを指定して遷移する
        visit('/users/sign_up')
        # 新規登録画面に遷移しているか確認
        expect(page).to have_current_path(new_user_registration_path)
      end
    end
  end
  describe "editアクション" do
    it "マイページの編集ボタンを押すと、編集ページに遷移する" do

    end
  end
  describe "createアクション" do
    before do
      # パスを指定して新規登録ページに遷移する
      visit(new_user_registration_path)
      # 「新規登録」文字列があるか検証(h2)
      expect(page).to have_selector('h2', text: '新規登録')
    end
    context "正常系" do
      it "入力必須のフォームに値を入れて登録出来る" do
        # 各フォームに必要事項を記入する
        fill_in 'ユーザー名', with: '例え太郎'
        fill_in 'メールアドレス', with: 'tatoe@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        # 登録ボタンを押す
        click_button '新規登録'
        # トップページに遷移し、「登録完了のフラッシュメッセージ」が表示されているか検証
        expect(page).to have_current_path(root_path)
        expect(page).to have_selector('.alert-info', text: '新規登録が完了しました。')
        # 登録したユーザーで認証済みかどうか検証(ログアウトボタンが表示されているか確認)
        expect(page).to have_link('ログアウト')
      end
    end

    context "異常系" do
      it "ユーザー名を入れていない時" do
        fill_in 'メールアドレス', with: 'tatoe@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        click_button '新規登録'
        # トップページに遷移し、「登録完了のフラッシュメッセージ」が表示されているか検証
        expect(page).to have_current_path(new_user_registration_path)
        expect(page).to have_selector('.alert-error', text: 'ニックネームを入力してください')
        # 登録したユーザーで認証済みかどうか検証(ログアウトボタンが表示されているか確認)
        expect(page).to have_link('ログイン')
        expect(page).to have_link('新規登録')
      end

      it "メールアドレスを入れていない時" do
        fill_in 'ユーザー名', with: '例え太郎'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        click_button '新規登録'
        expect(page).to have_current_path(new_user_registration_path)
        expect(page).to have_selector('.alert-error', text: 'メールアドレスを入力してください')
        expect(page).to have_link('ログイン')
        expect(page).to have_link('新規登録')
      end

      it "パスワードを入れていない時" do
        fill_in 'ユーザー名', with: '例え太郎'
        fill_in 'メールアドレス', with: 'tatoe@example.com'
        fill_in '確認用パスワード', with: 'password'
        click_button '新規登録'
        expect(page).to have_current_path(new_user_registration_path)
        expect(page).to have_selector('.alert-error', text: 'パスワードを入力してください')
        expect(page).to have_link('ログイン')
        expect(page).to have_link('新規登録')
      end

      it "パスワードと確認用パスワードが一致しない時" do
        fill_in 'ユーザー名', with: '例え太郎'
        fill_in 'メールアドレス', with: 'tatoe@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password2'
        click_button '新規登録'
        expect(page).to have_current_path(new_user_registration_path)
        expect(page).to have_selector('.alert-error', text: '確認用パスワードとパスワードの入力が一致しません')
        expect(page).to have_link('ログイン')
        expect(page).to have_link('新規登録')
      end
    end
  end
  describe "updateアクション" do
    context "正常系" do
      it "全ての値を変更した後、マイページに遷移する" do

      end
    end
    context "異常系" do
      it "ユーザー名・メールアドレスが空欄の場合、フラッシュメッセージを返す" do
        
      end
    end
  end
end
