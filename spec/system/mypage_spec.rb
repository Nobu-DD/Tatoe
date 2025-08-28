require 'rails_helper'

RSpec.describe "Mypage", type: :system do
  before do
    @user = create(:user)
  end
  describe 'newアクション' do
    it 'フッターのマイページボタンを押すと、マイページに遷移する' do
      # 作成したユーザ-にログインする
      sign_in(@user)
      # トップページに遷移する
      visit(root_path)
      # フッターのマイページボタンをクリックする
      click_link 'マイページ'
      # マイページのpathに遷移しているか検証
      expect(page).to have_current_path(mypage_path(@user))
      # ページタイトルがマイページと表示されているか検証
      expect(page).to have_selector('h2', 'マイページ')
      # 認証しているユーザー情報が表示されているか検証(ニックネーム、メールアドレス)
      expect(page).to have_selector('p', @user.name)
      expect(page).to have_selector('p', @user.email)
    end
    it '未認証だった場合、ログインページに遷移する。ログイン後マイページに遷移' do
      # トップページに遷移する
      visit(root_path)
      # フッターのマイページボタンをクリックする
      click_link 'マイページ'
      # ログイン画面に遷移しているか検証
      expect(page).to have_current_path(new_user_session_path)
      # 作成したユーザー情報を入力する
      fill_in 'メールアドレス', with: @user.email
      fill_in 'パスワード', with: @user.password
      # ログインボタンをクリック
      click_button 'ログイン'
      # マイページのpathに遷移しているか検証
      expect(page).to have_current_path(mypage_path(@user))
      # ログイン完了のフラッシュメッセージが入力されているか検証
      expect(page).to have_selector('.alert-info', text: 'ログインが完了しました。')
      # ページタイトルがマイページと表示されているか検証
      expect(page).to have_selector('h2', 'マイページ')
      # 認証しているユーザー情報が表示されているか検証(ニックネーム、メールアドレス)
      expect(page).to have_selector('p', @user.name)
      expect(page).to have_selector('p', @user.email)
    end
  end
end