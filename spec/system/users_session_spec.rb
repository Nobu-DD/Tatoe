require 'rails_helper'

RSpec.describe "UsersSession", type: :system do
  before do
    @user = create(:user)
    # name { Faker::Name.name },email { Faker::Internet.unique.email }, password { 'password' }, password_confirmation { 'password' }
  end
  describe "newアクション" do
    context "正常系" do
      it "ログイン画面に遷移する" do
        # パスを指定して遷移する
        visit('/users/sign_in')
        # 新規登録画面に遷移しているか確認
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
  describe "createアクション" do
    before do
      visit(new_user_session_path)
      expect(page).to have_selector('h2', text: 'ログイン')
      @user_wrong = @user
    end
    context "正常系" do
      it "メールアドレス、パスワードを入れると、ログインが成功する" do
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: @user.password
        click_button 'ログイン'
        expect(page).to have_current_path(root_path)
        expect(page).to have_selector('.alert-info', text: 'ログインが完了しました。')
        # 登録したユーザーで認証済みかどうか検証(ログアウトボタンが表示されているか確認)
        expect(page).to have_link('ログアウト')
      end
    end
    context "異常系" do
      it "メールアドレスが「未入力」または「違っている」" do
        @user_wrong.email = "wrong" + @user.email
        # メールアドレス未入力の場合
        fill_in 'パスワード', with: @user_wrong.password
        click_button 'ログイン'
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_selector('.alert-error', text: 'メールアドレスまたはパスワードが違います。')
        # 違うメールアドレスを入力した場合
        fill_in 'メールアドレス', with: @user_wrong.email
        fill_in 'パスワード', with: @user_wrong.password
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_selector('.alert-error', text: 'メールアドレスまたはパスワードが違います。')
        # 登録したユーザーで認証されていないかどうか検証(ログイン、新規登録ボタンが表示されているか)
        expect(page).to have_link('ログイン')
        expect(page).to have_link('新規登録')
      end
      it "パスワードが「未入力」または「違っている」" do
        @user_wrong.password = "wrong" + @user.password
        # パスワード未入力の場合
        fill_in 'メールアドレス', with: @user_wrong.email
        click_button 'ログイン'
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_selector('.alert-error', text: 'メールアドレスまたはパスワードが違います。')
        # 違うパスワードを入力した場合
        fill_in 'メールアドレス', with: @user_wrong.email
        fill_in 'パスワード', with: @user_wrong.password
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_selector('.alert-error', text: 'メールアドレスまたはパスワードが違います。')
        # 登録したユーザーで認証されていないかどうか検証(ログイン、新規登録ボタンが表示されているか)
        expect(page).to have_link('ログイン')
        expect(page).to have_link('新規登録')
      end
    end
  end
  describe "destroyアクション" do
    context "正常系" do
      it "ログアウトボタンを押すとログアウト出来る" do
        visit(new_user_session_path)
        expect(page).to have_selector('h2', text: 'ログイン')
        fill_in 'メールアドレス', with: @user.email
        fill_in 'パスワード', with: @user.password
        click_button 'ログイン'
        click_link 'ログアウト'
        expect(page).to have_selector('.alert-info', text: 'ログアウトが完了しました。')
      end
    end
  end
end
