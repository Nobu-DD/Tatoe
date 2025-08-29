class MypagesController < ApplicationController
  def show
    @user = User.includes(:topics, :answers, :genres).find(current_user.id)
  end
end
