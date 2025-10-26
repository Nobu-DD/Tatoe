class RankingsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ topics_index answers_index ]

  def topics_index
    @q = Topic.ransack(params)
    @sort = @q.sorts.empty? ? "likes_count desc" : params[:s]
    @q.sorts = @sort
    @topics = @q.result(distinct: true).includes(:user, :genres, :hints).limit(5)
  end

  def answers_index
    @q = Answer.ransack(params)
    @sort = @q.sorts.empty? ? "reactions_count desc" : params[:s]
    @answer_period = params[:published_at_gteq].present? ? params[:published_at_gteq] : false
    @q.sorts = @sort
    @answers = @q.result(distinct: true).includes(:user, :topic, :reactions, :comments).limit(5)
    @reactions = Reaction.all
  end
end
