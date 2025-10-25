class RankingsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ topics_index answers_index ]

  def topics_index
    @q = Topic.ransack(params)
    @q.sorts = @q.sorts.empty? ? "likes_count desc" : params[:s]
    @sort = params[:s]
    @topics = @q.result(distinct: true).includes(:user, :genres, :hints).limit(5)
  end

  def answers_index
    @q = Answer.ransack(params)
    @q.sorts = @q.sorts.empty? ? "reactions_count desc" : params[:s]
    @sort = params[:s]
    @answers = @q.result(distinct: true).includes(:user, :topic, :reactions, :comments).limit(5)
    @reactions = Reaction.all
  end

  private

  # def published_at_params
  # params.require(:q).permit(
  #   :published_at_gteq
  # )
  # end
end