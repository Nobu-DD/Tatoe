require 'rails_helper'

RSpec.describe "Topic", type: :model do
  describe 'バリデーションチェック' do
    context 'ユーザーが投稿するお題を保存させる時' do
      it '全ての項目を入力した時' do
      end
      it 'お題タイトルのみ入力した時' do
      end
    end
    context 'ユーザーが投稿するお題を保存させない時' do
      it 'お題タイトルが入力されない時' do
      end
      it 'ユーザーが未ログインの場合' do
      end
    end
  end
end
