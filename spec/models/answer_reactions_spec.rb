require 'rails_helper'

RSpec.describe "AnswerReaction", type: :model do
  describe 'バリデーションチェック' do
    before do
      @user = create(:user)
      @topic = create(:topic, user_id: @user.id)
      @answer = create(:answer, user_id: @user.id, topic_id: @topic.id)
      @reaction_empathy = create(:reaction, :empathy)
      @reaction_consent = create(:reaction, :consent)
      @reaction_smaile = create(:reaction, :smile)
    end

    context '正常系：例えに対してリアクション(3種類)登録ができる' do
      it '何も登録されていない時' do
        # answer_reactionのモデルをuserとanswerのidを使用して作成(モデルインスタンスのみ)
        answer_empathy = create(:answer_reaction, user_id: @user.id, answer_id: @answer.id, reaction_id: @reaction_empathy.id)
        # expectでbe_validに引っかからないか検証
        expect(answer_empathy).to be_valid
      end
      it '共感が既に登録済みの時、納得を登録する時' do
        answer_empathy = create(:answer_reaction, user_id: @user.id, answer_id: @answer.id, reaction_id: @reaction_empathy.id)
        reaction_consent = create(:answer_reaction, user_id: @user.id, answer_id: @answer.id, reaction_id: @reaction_consent.id)
        expect(reaction_consent).to be_valid
      end
    end
  end
end
