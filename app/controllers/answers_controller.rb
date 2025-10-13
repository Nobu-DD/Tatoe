class AnswersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  def new
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    @answer = @topic.answers.build
  end

  def show
    @topic = Topic.includes(:genres).find(params[:topic_id])
    @answer = Answer.includes(:user, :comments, :reactions).find(params[:id])
    @reactions = Reaction.all
    @sort_by = params[:sort] == "asc" ? "asc" : "desc"
    @comments = @answer.comments.order(published_at: @sort_by).page(params[:page]).per(10)
    @new_comment = @answer.comments.build
  end

  def create
    @answer = current_user.answers.build(answer_params)
    @reactions = Reaction.all
    if @answer.save
      @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
      flash.now.notice = t("answer.create.success")
    else
      render :new, status: :unprocessable_entity, notice: t("spots.create.failure")
    end
  end

  def edit
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    @answer = current_user.answers.find(params[:id])
    @reactions = Reaction.all
  end

  def update
    @answer = current_user.answers.find(params[:id])
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:topic_id])
    @reactions = Reaction.all
    if @answer.update(answer_params)
      flash.now.notice = t("answer.update.success")
    else
      flash.now.alert = t("answer.update.failure")
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy!
    @answers = Topic.includes(:answers).find(params[:topic_id]).answers
    flash.now.notice = t("answer.deleted.success")
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
