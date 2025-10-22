class RankingsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ topics_index answers_index ]

  def topics_index
    @q = Topic.ransack(search_params)
    @q.sorts = params[:s].blank? ? "likes_count desc" : params[:s]
    @topics = @q.result(distinct: true).includes(:user, :genres, :hints).limit(5)
  end

  def answers_index
    @q = Answer.ransack(search_params)
    @q.sorts = params[:s].blank? ? "reactions_count desc" : params[:s]
    @answers = @q.result(distinct: true).includes(:user, :topic, :reactions, :comments).limit(5)
    @reactions = Reaction.all
  end

  private

  def search_params
  return params[:q] if params[:q].blank?

  params.require(:q).permit(
    :published_at_gteq, :published_at_lteq, :likes_count_desc, :answers_count_desc, :reactions_count_desc, :empathy_count_desc, :consent_count_desc, :smile_count_desc
  )
  end
end