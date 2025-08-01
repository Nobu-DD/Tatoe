class TopController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @topics = Topic.includes(:user, :genres, :hints).order("published_at desc")
    @pickup_topics = Topic.with_active_pickup.includes(:user, :genres, :hints)
  end
end
