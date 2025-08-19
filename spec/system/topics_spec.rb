require 'rails_helper'

RSpec.describe "Topics", type: :system do
  describe 'indexアクション' do
    it 'お題検索ページにて登録順にお題を一覧表示する(投稿が新しい順)' do
    end
    it '検索フォームでお題の「タイトル」「説明」を入れると検索することが出来る' do
    end
  end
  describe 'newアクション' do
    it 'お題投稿ボタンを押すと、お題投稿画面に遷移する' do
    end
  end
  describe 'createアクション' do
    context '正常系' do
      it 'お題のタイトルを入力すれば、お題を投稿出来る' do
      end
    end
    context '異常系' do
      it 'タイトルが未入力だと、エラーメッセージが表示する' do
      end
    end
  end
  describe 'showアクション' do
    it 'お題を選択すると、お題詳細ページに遷移' do
    end
    it '自分の作成したお題には、お題を編集・削除ボタンが表示' do
    end
    it '自分の作成した例えには、編集・削除ボタンが表示' do
    end
    it '自分以外の例えには、「確かに！」アクションボタンが表示' do
    end
  end
  describe 'editアクション' do
    it '作成したお題に表示する「お題を編集ボタン」を押すと、お題編集ページに遷移する' do
    end
    it '編集前のデータが各フォームに入力されている' do
    end
  end
  describe 'updateアクション' do
    context '正常系' do
      it '「お題を更新ボタン」を押すと、お題が更新される' do
      end
    end
    context '異常系' do
      it 'お題が入力されていないと、エラーメッセージが表示される' do
      end
    end
  end
  describe 'destroyアクション' do
    it '「お題を削除ボタン」を押すと、お題が削除される' do
    end
  end
end
