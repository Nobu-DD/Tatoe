require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "認証前" do
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
          expect(page).to have_selector('.alert-error', text: 'ユーザー名を入力してください')
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
  end
  describe "認証後" do
    before do
      @user = create(:user)
      sign_in(@user)
    end
    describe "editアクション" do
      it "マイページの編集ボタンを押すと、編集ページに遷移する" do
        # マイページに遷移する
        visit(mypage_path)
        # マイページの編集ボタンを押す
        click_link "編集"
        # マイページの編集ページに遷移しているか検証
        expect(page).to have_current_path(edit_user_registration_path(@user))
        expect(page).to have_selector("h2", text: "ユーザー編集")
      end
    end
    describe "updateアクション" do
      context "正常系" do
        it "全ての値を変更した後、マイページに遷移する" do
          # ユーザー編集に直接遷移する
          visit(edit_user_registration_path(@user))
          # ユーザー編集の各フォームに入力する
          fill_in 'ユーザー名', with: '例え太郎'
          fill_in 'メールアドレス', with: 'tatoe@example.com'
          fill_in '好き・得意ジャンル', with: 'プログラミング Rails RUNTEQ'
          fill_in '本人確認のため、パスワード入力をお願いします', with: @user.password
          # 変更ボタンを押す
          click_button '変更'
          # マイページに遷移しているか検証
          expect(page).to have_current_path(mypage_path)
          # フラッシュメッセージが表示されているか検証
          expect(page).to have_selector(".alert-info", text: "ユーザー情報を変更しました")
          # ユーザーの各項目が、編集ページで入れていた値になっているか検証
          expect(page).to have_selector("span", text: "例え太郎")
          expect(page).to have_selector("span", text: "tatoe@example.com")
          expect(page).to have_selector("span", text: "プログラミング")
          expect(page).to have_selector("span", text: "Rails")
          expect(page).to have_selector("span", text: "RUNTEQ")
        end
        it "好き・得意ジャンルを少なくした時、DBから削除されている" do
          # ユーザーにジャンルを3個登録しておく
          visit(edit_user_registration_path(@user))
          fill_in '好き・得意ジャンル', with: 'プログラミング Rails RUNTEQ'
          click_button '変更'
          visit(edit_user_registration_path(@user))
          # 好き・得意ジャンルの内2つ消去して入力
          fill_in '好き・得意ジャンル', with: 'プログラミング'
          # 変更ボタンを押す
          click_button '変更'
          # マイページに遷移しているか検証
          expect(page).to have_current_path(mypage_path)
          # ユーザーのmygenreに消去したジャンルが存在していないか検証
          after_user = User.includes(:genres).find(@topics[0].id)
          after_genres = after_user.genres.map(&:name)
          expect(after_genres).to_not include("Rails", "RUNTEQ")
        end
      end
      context "異常系" do
        it "ユーザー名・メールアドレスが空欄の場合、フラッシュメッセージを返す" do
          # 編集ページに直接遷移する
          visit(edit_user_registration_path(@user))
          # ユーザー名を空白にする
          fill_in 'ユーザー名', with: ''
          fill_in '本人確認のため、パスワード入力をお願いします', with: @user.password
          # 変更ボタンを押す
          click_button '変更'
          # 編集ページに遷移するか検証
          expect(page).to have_current_path(edit_user_registration_path(@user))
          # ユーザー名を入力していないというフラッシュメッセージを出力しているか検証
          expect(page).to have_selector('.alert-error', text: 'ユーザー名を入力してください')
          # メールアドレスを空白にする
          fill_in 'メールアドレス', with: ''
          fill_in '本人確認のため、パスワード入力をお願いします', with: @user.password
          # 変更ボタンを押す
          click_button '変更'
          # 編集ページに遷移するか検証
          expect(page).to have_current_path(edit_user_registration_path(@user))
          # メールアドレスを入力していないというフラッシュメッセージを出力しているか検証
          expect(page).to have_selector('.alert-error', text: 'メールアドレスを入力してください')
        end
      end
    end
  end
end
