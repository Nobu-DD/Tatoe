class AnswersController < ApplicationController
  def new
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    @answer = @topic.answers.build
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    if @answer.save
      redirect_to @topic, notice: t("topics.create.success")
    else
      render :new, status: :unprocessable_entity, notice: t("spots.create.failure")
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :reason, :topic_id)
  end
end
