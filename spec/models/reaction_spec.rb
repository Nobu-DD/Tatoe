require 'rails_helper'

RSpec.describe "Reaction", type: :model do
  describe 'バリデーションチェック' do
    before do
      @reaction = build(:reaction)
    end
    context '管理者がリアクションを登録出来る' do
      it 'リアクション名を指定した時' do
        expect(@reaction).to be_valid
      end
    end
    context 'リアクションを登録出来ない' do
      it 'リアクション名が空の場合' do
        @reaction.name = ""
        expect(@reaction).to be_invalid
        expect(@reaction.errors[:name]).to eq([ "を入力してください" ])
      end
    end
  end
end
