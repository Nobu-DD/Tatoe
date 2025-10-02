class AnswersController < ApplicationController
  def new
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    @answer = @topic.answers.build
  end

  def show
    answer = Answer.includes(:user, :comments).find(params[:answer_id])
    @comments = answer.comments.order(published_at: :desc)
    @new_comment = answer.comments.build
  end

  def create
    @answer = current_user.answers.build(answer_params)
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    if @answer.save
      redirect_to @topic, notice: t("answer.create.success")
    else
      render :new, status: :unprocessable_entity, notice: t("spots.create.failure")
    end
  end

  def edit
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    @answer = current_user.answers.find(params[:id])
  end

  def update
    @answer = current_user.answers.find(params[:id])
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    if @answer.update(answer_params)
      redirect_to @topic, notice: t("answer.update.success")
    else
      render :edit, status: :unprocessable_entity, alert: t("answer.update.failure")
    end
  end

  def destroy
    answer = current_user.answers.find(params[:id])
    answer.destroy!
    redirect_to topic_path(id: answer.topic_id), notice: t("answer.deleted.success")
  end

  def generate_ai
    request_params = params.slice(:theme, :topic)
    response = GeminiGenerationService.new(:answer, request_params).run
    render json: response
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :reason, :topic_id)
  end
end
