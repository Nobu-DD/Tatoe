# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :set_custom_return_to, only: [:new]
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

  # 認証後のリダイレクト先を設定(topics/[:id]/newにアクセスしようとした時)
  def set_custom_return_to
    request_path = session[:user_return_to]

    if request_path =~ /\/topics\/\d+\/answers\/new/
      redirect_path = request_path.sub("/answers/new", "")
      session[:user_return_to] = redirect_path
    end
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
