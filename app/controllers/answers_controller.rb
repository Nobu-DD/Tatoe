class AnswersController < ApplicationController
  def new
    @answer = Topic.include(:answers).find(params[:id])answers.build
  end

  def create

  end
end