class LikesController < ApplicationController
  def create
    @like = current_user.likes.build(like_params)
    @like.save
    @type = like_params[:likeable_type]
    @object = @like.likeable
  end

  def destroy
    @like = current_user.likes.build(like_params)
    @type = like_params[:likeable_type]
    @object = @like.likeable
    @like.destroy
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end
end