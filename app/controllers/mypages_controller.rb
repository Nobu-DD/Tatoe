class MypagesController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def show
  end

  def update
    if @user.update(avatar_params)
      redirect_to mypage_path, notice: "アバターを登録しました。"
    else
      @user.reload
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @user.remove_avatar!
    if @user.save
      redirect_to mypage_path, notice: "アバターをリセットしました。"
    else
      @user.reload
      render :show, status: :unprocessable_entity, alert: "アバターリセットに失敗しました。再度お試しください。"
    end
  end

  private

  def set_user
    @user = User.includes(:topics, :answers, :genres).find(current_user.id)
  end

  def avatar_params
    params.permit(:avatar)
  end
end
