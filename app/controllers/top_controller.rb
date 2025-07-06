class TopController < ApplicationController
  def index
    @topics = Topic.includes(:user, :genres, :hints)
  end
end
