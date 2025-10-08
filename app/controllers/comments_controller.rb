class CommentsController < ApplicationController
  def create
    @new_comment = current_user.comments.build(comment_params)
    @new_comment[:answer_id] = params[:answer_id]
    @topic = Topic.find(params[:topic_id])
    @answer = @new_comment.answer
    @reactions = Reaction.all
    @sort_by = "desc"
    @comments = @answer.comments.order(published_at: @sort_by).page(1).per(10)
    if @new_comment.save
      redirect_to topic_answer_path(@topic, @answer), notice: t("comment.create.success")
    else
      render "answers/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
