require 'rails_helper'

RSpec.describe "Genre", type: :model do
  describe 'バリデーションチェック' do
    before do
      @genre = build(:genre)
    end
    context 'ジャンルを登録する時' do
      it 'ジャンル名があれば登録出来る' do
        expect(@genre).to be_valid
      end
    end
    context 'ジャンルを登録させない時' do
      it 'ジャンル名が空白、またはnilの場合登録できない' do
        @genre.name = " "
        expect(@genre).to be_invalid
        expect(@genre.errors[:name]).to eq([ "を入力してください。" ])
        @genre2 = build(:genre)
        @genre2.name = nil
        expect(@genre2).to be_invalid
        expect(@genre2.errors[:name]).to eq([ "を入力してください。" ])
      end
    end
  end
end
