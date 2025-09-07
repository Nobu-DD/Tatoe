class MypagesController < ApplicationController
  def show
    @user = User.includes(:topics, :answers, :genres).find(current_user.id)
  end
  def update
    @user = User.includes(:topics, :answers, :genres).find(current_user.id)
    if @user.update(avatar_params)
      redirect_to mypage_path, notice: "アバターを登録しました。"
    else
      @user.reload
      render :show, status: :unprocessable_entity
    end
  end
  def destroy
    @user = User.includes(:topics, :answers, :genres).find(current_user.id)
    @user.remove_avatar!
    if @user.save
      redirect_to mypage_path, notice: "アバターをリセットしました。"
    else
      @user.reload
      render :show, status: :unprocessable_entity, alert: "アバターリセットに失敗しました。再度お試しください。"
    end
  end

  private

  def avatar_params
    params.permit(:avatar)
  end
end
