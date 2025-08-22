require 'rails_helper'

RSpec.describe "Answer", type: :model do
  describe 'バリデーションチェック' do
    before do
      @user = create(:user)
      @topic = build(:topic)
      @topic.user_id = @user.id
      @topic.save
      @answer = build(:answer)
      @answer.user_id = @user.id
      @answer.topic_id = @topic.id
    end
    context 'お題に対して例えを投稿出来る' do
      it '全ての値が入力されている時' do
        expect(@answer).to be_valid
      end
      it '理由・説明が書かれていない時' do
        @answer.reason = ""
        expect(@answer).to be_valid
      end
    end
    context 'お題に例えを投稿させない' do
      it '例えが入力されていない時' do
        @answer.body = ""
        expect(@answer).to be_invalid
        expect(@answer.errors[:body]).to eq([ "を入力してください" ])
      end
    end
  end
end
