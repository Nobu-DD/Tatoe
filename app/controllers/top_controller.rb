class TopController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @topics = Topic.includes(:user, :answers, :genres, :hints, :likes).order("published_at desc").page(params[:page]).per(10)
    @pickup_topics = Topic.with_active_pickup.includes(:user, :genres, :hints)
  end
end
