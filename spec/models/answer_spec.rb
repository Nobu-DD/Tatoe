require 'rails_helper'

RSpec.describe "Answer", type: :model do
  describe 'バリデーションチェック' do
    context 'お題に対して例えを投稿出来る' do
      it '全ての値が入力されている時' do
      end
      it '理由・説明が書かれていない時' do
      end
    end
    context 'お題に例えを投稿させない' do
      it '例えが入力されていない時' do
      end
    end
  end
end
