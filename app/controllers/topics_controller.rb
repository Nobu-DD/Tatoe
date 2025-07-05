class TopicsController < ApplicationController
  def new
    @topic = Topic.new
    3.times { @topic.hints.build }
  end

  def create
    @topic = current_user.topics.new(topic_params)
    @topic.genre_names = params[:topic][:genre_names]
    raise
    if @topic.save
      redirect_to @topic, notice: t("topics.create.success")
    else
      render :new, status: :unprocessable_entity, notice: t("spots.create.failure")
    end
  end

  private

  def topic_params
    params.require(:topic).permit(
      :title, :description,
      hints_attributes: [:id, :body, :_destroy]
    )
  end
end
