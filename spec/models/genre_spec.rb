require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'バリデーションチェック' do
    context 'ジャンルを登録する時' do
      it 'ジャンル名があれば登録出来る' do
      end
    end
    context 'ジャンルを登録させない時' do
      it 'ジャンル名が空白、またはnilの場合登録できない' do
      end
    end
  end
end