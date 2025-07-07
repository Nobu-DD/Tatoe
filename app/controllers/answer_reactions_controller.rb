class AnswerReactionsController < ApplicationController
  def create
    @answer = Answer.find(params[:answer_id])
  end

  def destroy
  end
end
