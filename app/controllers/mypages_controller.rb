class MypagesController < ApplicationController
  def show
    @user = User.includes(:topics, :answers, :genres).find(current_user.id)
  end
  def update
    user = current_user
    if user.update(avatar: avatar_params[:avatar])
      redirect_to mypage_path, notice: "アバターを登録しました。"
    else
      render :edit, status: :unprocessable_entity, alert: "アバター登録に失敗しました。登録出来るファイル拡張子を確認の上、再度お試しください。"
    end
  end
  def destroy
    user = current_user
    user.remove_avatar!
    if user.save
      redirect_to mypage_path, notice: "アバターをリセットしました。"
    else
      render :edit, status: :unprocessable_entity, alert: "アバターリセットに失敗しました。再度お試しください。"
    end
  end

  private

  def avatar_params
    params.permit(:avatar)
  end
end
