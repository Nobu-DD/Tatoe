require 'rails_helper'

RSpec.describe "Pickup", type: :model do
  describe 'バリデーションチェック' do
    context 'お題に対してピックアップ期間を指定できる' do
      it 'ピックアップが(開始時間 < 終了時間)で入力' do
      end
    end
    context 'お題に対してピックアップ期間を指定出来ない' do
      it 'ピックアップが(開始時間 > 終了時間)で入力' do
      end
      it '開始時間が入力されていない' do
      end
      it '終了時間が入力されていない' do
      end
    end
  end
end