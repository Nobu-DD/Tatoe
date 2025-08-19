require 'rails_helper'

RSpec.describe "Answers", type: :system do
  describe 'newアクション' do
    it '例えを投稿！ボタンを押すと、例え作成ページに遷移' do

    end
  end
  describe 'createアクション' do
    context '正常系' do
      it '例えを記述すれば、投稿できる' do

      end
    end
    context '異常系' do
      it '例えが未入力だと、エラーメッセージが表示する' do

      end
    end
  end
  describe 'editアクション' do
    it '作成した例えに表示する「編集ボタン」を押すと、例え編集ページに遷移する' do

    end
    it '編集前のデータが各フォームに入力されている' do

    end
  end
  describe 'updateアクション' do
    context '正常系' do
      it '「変更ボタン」を押すと、例えが更新される' do

      end
    end
    context '異常系' do
      it '例えが入力されていないと、エラーメッセージが表示される' do

      end
    end
  end
  describe 'destroyアクション' do
    it '例えにある「削除ボタン」を押すと、例えが削除される' do
      
    end
  end
end