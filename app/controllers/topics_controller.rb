class TopicsController < ApplicationController
  def new
    @topic = current_user.topics.build
  end

  def create
    @topic = current_user.topics.new(topic_params)
    raise
    if @topic.save
      @topic.genres_save(genre_params)
    end
  end
  private

  def topic_params
    params.require(:topic).permit(:title, :description)
  end

  def genre_params
    params[:genre][:genre_names].split('').uniq
  end
end
