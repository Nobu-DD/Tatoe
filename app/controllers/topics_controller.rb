class TopicsController < ApplicationController
  def index
    @q = Topic.ransack(params[:q])
    @topics = @q.result(distinct: true).includes(:user, :genres, :hints).page(params[:page]).order("published_at desc")
  end

  def new
    @topic = Topic.new
    3.times { @topic.hints.build }
  end

  def create
    @topic = current_user.topics.new(topic_params)
    if @topic.save
      redirect_to @topic, notice: t("topics.create.success")
    else
      render :new, status: :unprocessable_entity, notice: t("spots.create.failure")
    end
  end

  def show
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:id])
  end

  private

  def topic_params
    params.require(:topic).permit(
      :title, :description, :genre_names,
      hints_attributes: [ :id, :body, :_destroy ]
    )
  end
end
