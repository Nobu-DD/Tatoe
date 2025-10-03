class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      respond_to do |format|
        render turbo_stream: turbo_stream.prepend(:comments)
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :answer_id)
  end

end