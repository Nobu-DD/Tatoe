class LikeController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @like.save
  end

  def destroy
    @like = current_user.likes.build(like_params)
    @like.destroy
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end