class AnswerReactionsController < ApplicationController
  def create
    @answer = Answer.find(params[:answer_id])
    @reaction = Reaction.find(params[:reaction_id])
    current_user.answer_reaction(@answer, @reaction)
  end

  def destroy
    @answer = Answer.find(params[:answer_id])
    @reaction = Reaction.find(params[:reaction_id])
    current_user.unanswer_reaction(@answer, @reaction)
    @answer.reload
  end
end
