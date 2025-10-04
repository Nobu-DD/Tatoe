class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  def index
    @q = Topic.ransack(params[:q])
    @topics = @q.result(distinct: true).includes(:user, :genres, :hints).page(params[:page]).order("published_at desc")
  end

  def new
    @topic = Topic.new
    3.times { @topic.hints.build }
  end

  def create
    @topic = current_user.topics.build(topic_params)
    if @topic.save
      redirect_to @topic, notice: t("topic.create.success")
    else
      render :new, status: :unprocessable_entity, alert: t("topic.create.failure")
    end
  end

  def show
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:id])
    @answers = @topic.answers.order(created_at: :desc)
    @reactions = Reaction.all
  end

  def edit
    @topic = current_user.topics.find(params[:id])
    @topic.genre_names = @topic.edit_genre_names_form
  end

  def update
    @topic = current_user.topics.find(params[:id])
    if @topic.update(topic_params)
      redirect_to @topic, notice: t("topic.update.success")
    else
      render :edit, status: :unprocessable_entity, alert: t("topic.create.failure")
    end
  end

  def destroy
    topic = current_user.topics.find(params[:id])
    topic.destroy!
    redirect_to topics_path, notice: t("topic.deleted.success")
  end

  def generate_ai
    request_params = params.slice(:genre, :compare)
    response = GeminiGenerationService.new(:topic, request_params).run
    render json: response
  end

  private

  def topic_params
    params.require(:topic).permit(
      :title, :description, :genre_names,
      hints_attributes: [ :id, :body, :_destroy ]
    )
  end
end
