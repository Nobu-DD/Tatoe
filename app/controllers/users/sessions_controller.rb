# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :store_user_location!, only: [:new]
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  private

  def store_user_location!
    # トップページ（root_path）以外からログイン画面に遷移した場合ログイン後、元のページに遷移する
    if params[:redirect_url].present?
      store_location_for(:user, params[:redirect_url])
    end
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
