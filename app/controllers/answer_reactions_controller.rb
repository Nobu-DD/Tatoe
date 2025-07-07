class AnswerReactionsController < ApplicationController
  def create
    @answer = Answer.find(params[:answer_id])
    current_user.
  end

  def destroy

  end
end