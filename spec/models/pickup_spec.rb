require 'rails_helper'

RSpec.describe "Pickup", type: :model do
  describe 'バリデーションチェック' do
    before do
      @user = create(:user)
      @topic = build(:topic)
      @topic.user_id = @user.id
      @topic.save
      @pickup = build(:pickup)
      @pickup.topic_id = @topic.id
    end
    context 'お題に対してピックアップ期間を指定できる' do
      it 'ピックアップが(開始時間 < 終了時間)で入力' do
        expect(@pickup).to be_valid
      end
    end
    context 'お題に対してピックアップ期間を指定出来ない' do
      it 'ピックアップが(開始時間 > 終了時間)で入力' do
        @pickup.start_at = @pickup.end_at + 1.day
        expect(@pickup).to be_invalid
        expect(@pickup.errors[:start_at]).to eq([ "は終了日時より前に設定してください" ])
      end
      it '開始時間が入力されていない' do
        @pickup.start_at = nil
        expect(@pickup).to be_invalid
        expect(@pickup.errors[:start_at]).to eq([ "を入力してください" ])
      end
      it '終了時間が入力されていない' do
        @pickup.end_at = nil
        expect(@pickup).to be_invalid
        expect(@pickup.errors[:end_at]).to eq([ "を入力してください" ])
      end
    end
  end
end
