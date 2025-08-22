require 'rails_helper'

RSpec.describe "Topic", type: :model do
  describe 'バリデーションチェック' do
    before do
      @user = create(:user)
      @topic = build(:topic)
      @topic.user_id = @user.id
    end
    context 'ユーザーが投稿するお題を保存させる時' do
      it '全ての項目を入力した時' do
        expect(@topic).to be_valid
      end
      it 'お題タイトルのみ入力した時' do
        @topic.description = ""
        @topic.published_at = nil
        expect(@topic).to be_valid
      end
    end
    context 'ユーザーが投稿するお題を保存させない時' do
      it 'お題タイトルが入力されない時' do
        @topic.title = ""
        expect(@topic).to be_invalid
        expect(@topic.errors[:title]).to eq([ "を入力してください" ])
      end
      it 'ユーザーが未ログインの場合' do
        @topic.user_id = nil
        expect(@topic).to be_invalid
      end
    end
  end
end
