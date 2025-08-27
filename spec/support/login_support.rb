module LoginSupport
  def sign_in(user)
    unless current_path == "/users/sign_in"
      visit(new_user_session_path)
    end
    expect(page).to have_current_path(new_user_session_path)
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    expect(page).to have_selector('.alert-info', text: 'ログインが完了しました。')
  end
end
