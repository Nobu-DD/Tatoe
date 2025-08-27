require 'rails_helper'

RSpec.describe "Answers", type: :system do
  before do
    # 例えを投稿するために、ログイン認証する
    @user = create(:user)
    @topic = create(:topic, user_id: @user.id)
    sign_in(@user)
    # 投稿したい例えページに遷移
    visit(topic_path(@topic))
  end
  describe 'newアクション' do
    it '例えを投稿！ボタンを押すと、例え作成ページに遷移' do
      # お題詳細ページの'例えを投稿！'ボタンを押す
      click_link '例えを投稿！'
      # たとえ作成ページに遷移しているか検証
      expect(page).to have_selector('h2', text: "例え投稿")
      expect(page).to have_current_path(new_topic_answer_path(@topic))
    end
  end
  describe 'createアクション' do
    context '正常系' do
      it '例えを記述すれば、投稿できる' do
        visit(new_topic_answer_path(@topic))
        fill_in '例えをこちらに', with: "Tatoeは〜〜です"
        click_button '投稿'
        expect(page).to have_selector('.alert-info', text: '例えを投稿しました。')
        expect(page).to have_current_path(topic_path(@topic))
        expect(page).to have_selector('p', text: 'Tatoeは〜〜です')
      end
    end
    context '異常系' do
      it '例えが未入力だと、エラーメッセージが表示する' do
        visit(new_topic_answer_path(@topic))
        click_button '投稿'
        expect(page).to have_selector('.alert-error', text: '例え内容を入力してください')
        expect(page).to have_current_path(new_topic_answer_path(@topic))
      end
    end
  end
  describe 'editアクション' do
    it '作成した例えに表示する「編集ボタン」を押すと、例え編集ページに遷移する' do
      answer = create(:answer, user_id: @user.id, topic_id: @topic.id)
      visit(topic_path(@topic))
      # 自分の作成した例えを押す
      click_button '編集'
      expect(page).to have_selector('h2', text: '例え編集')
      expect(page).to have_current_path(edit_topic_answer_path(@topic, answer))
      expect(page).to have_field('例えるなら...', with: answer.body)
    end
  end
  describe 'updateアクション' do
    context '正常系' do
      it '「変更ボタン」を押すと、例えが更新される' do
        answer = create(:answer, user_id: @user.id, topic_id: @topic.id)
        visit(edit_topic_answer_path(@topic, answer))
        fill_in '例えるなら...', with: 'Twitter！！(？)'
        fill_in '理由・説明', with: 'SNSでのコミュニケーションツールだから'
        click_button '変更'
        expect(page).to have_current_path(topic_path(@topic))
        expect(page).to have_selector('.alert-info', text: '例えを更新しました。')
        answer = Answer.find(answer.id)
        expect(answer.body).to eq("Twitter！！(？)")
        expect(answer.reason).to eq("SNSでのコミュニケーションツールだから")
      end
    end
    context '異常系' do
      it '例えが入力されていないと、エラーメッセージが表示される' do
        answer = create(:answer, user_id: @user.id, topic_id: @topic.id)
        visit(edit_topic_answer_path(@topic, answer))
        fill_in '例えるなら...', with: ''
        click_button '変更'
        expect(page).to have_current_path(edit_topic_answer_path(@topic, answer))
        expect(page).to have_selector('.alert-error', text: '例え内容を入力してください')
      end
    end
  end
  describe 'destroyアクション' do
    it '例えにある「削除ボタン」を押すと、例えが削除される' do
      answer = create(:answer, user_id: @user.id, topic_id: @topic.id)
      visit(topic_path(@topic))
      accept_confirm do
        click_button('削除')
      end
      expect(page).to have_selector('.alert-info', text: '例えを削除しました。')
      expect(Answer.exists?(answer.id)).to be_falsey
    end
  end
end
