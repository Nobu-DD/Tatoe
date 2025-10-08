class CommentsController < ApplicationController
  def edit
    @comment = Comment.includes(:user, :answer).find(params[:id])
    @answer = @comment.answer
    @topic = Topic.find(@answer.topic_id)
  end

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

  def update
    @comment = current_user.comments.find(params[:id])
    @comment[:answer_id] = params[:answer_id]
    @topic = Topic.find(params[:topic_id])
    @answer = @comment.answer
    if @comment.update(comment_params)
      flash.now.notice = t("comment.update.success")
    else
      flash.now.alert = t("comment.update.failure")
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment[:answer_id] = params[:answer_id]
    @comment.destroy!
    flash.now[:notice] = t("comment.deleted.success")
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
