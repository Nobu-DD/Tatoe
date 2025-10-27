# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [ :update ]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
    @user.genre_names = @user.edit_genre_names_form
  end

  # PUT /resource
  def update
    @user = current_user
    if @user.update(user_params)
      flash.now.notice = t("devise.registrations.user.updated")
    else
      flash.now.alert = t("devise.registrations.user.failure")
    end
  end

  def edit_password
  end

  def update_password
    if current_user.update_with_password(password_update_params)
      bypass_sign_in(current_user, scope: :user)
      flash[:notice] = t("devise.passwords.user.updated")
      redirect_to mypage_path
    else
      render :edit_password, status: :unprocessable_entity
    end
  end
  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :genre_names ])
  # end

  def user_params
    params.require(:user).permit(
      :name, :email, :genre_names
    )
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  def after_update_path_for(resource)
    mypage_path
  end

  def password_update_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
