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

    context '正常系：例えに対してリアクション(3つ)登録ができる' do
      it '何も登録されていない時' do
        
      end
    end
  end
end


