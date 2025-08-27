require 'rails_helper'

RSpec.describe "Topics", type: :system do
  before do
    @user = create(:user)
    @topics = create_list(:topic, 5, user_id: @user.id)
    create(:reaction)
  end
  describe 'indexアクション' do
    it 'お題検索ページにて登録順にお題を一覧表示する(投稿が新しい順)' do
      visit(root_path)
      click_link 'お題検索'
      expect(page).to have_current_path(topics_path)
      expected_datetimes = @topics.sort_by { |topic| topic.published_at }.reverse.map { |topic| I18n.l(topic.published_at) }
      actual_datetimes = all('.published-at').map(&:text)
      expect(actual_datetimes).to eq(expected_datetimes)
    end
    it '検索フォームでお題の「タイトル」「説明」を入れると検索することが出来る' do
      # 事前に作成しておいたtopicsを検索対象と検索対象外で分けておく
      search_topic = @topics[0]
      search_excluded_topics = @topics[1..4]
      # お題検索ページに遷移する
      visit(topics_path)
      # 検索フォームに登録したお題の「タイトル」を入力する
      fill_in 'お題タイトル、説明を検索...', with: "#{search_topic.title}"
      # 検索ボタンを押す
      click_button '検索'
      # 入力したお題が表示されているか検証
      expect(page).to have_current_path(topics_path)
      expect(page).to have_selector('.topic-title', text: "#{search_topic.title}")
      # 入力してないお題が表示されていないか検証
      search_excluded_topics.each do |topic|
        expect(page).to have_no_selector('.topic-title', text: "#{topic.title}")
      end
      # 説明を入力する
      fill_in 'お題タイトル、説明を検索...', with: "#{search_topic.description}"
      # 検索ボタンを押す
      click_button '検索'
      # 入力したお題が表示されているか検証
      expect(page).to have_selector('.topic-item', count: 1)
      expect(page).to have_selector('.topic-title', text: "#{search_topic.title}")
      # 入力してないお題が表示されていないか検証
      search_excluded_topics.each do |topic|
        expect(page).to have_no_selector('.topic-title', text: "#{topic.title}")
      end
    end
  end
  describe 'newアクション' do
    it 'お題投稿ボタンを押すと、お題投稿画面に遷移する' do
      # ログインページにてログイン処理を実施
      sign_in(@user)
      # フッターのお題投稿ボタンを押す
      click_link 'お題投稿'
      # お題新規投稿画面かどうか検証
      expect(page).to have_selector('h2', text: 'お題を投稿')
      expect(page).to have_current_path(new_topic_path)
    end
  end
  describe 'createアクション' do
    before do
      sign_in(@user)
      visit(new_topic_path)
    end
    context '正常系' do
      it 'お題のタイトルを入力すれば、お題を投稿出来る' do
        fill_in 'お題タイトル', with: 'Tatoeを別のアプリで例えると？'
        click_button 'お題を作成'
        expect(page).to have_selector('.alert-info', text: 'お題を投稿しました。')
        expect(page).to have_selector('h2', text: 'お題詳細')
        registered_topic = Topic.last
        expect(page).to have_current_path(topic_path(registered_topic))
        expect(page).to have_selector('h2', text: registered_topic.title)
      end
    end
    context '異常系' do
      it 'タイトルが未入力だと、エラーメッセージが表示する' do
        fill_in 'お題タイトル', with: ''
        click_button 'お題を作成'
        expect(page).to have_current_path(new_topic_path)
        expect(page).to have_selector('.alert-error', text: 'お題タイトルを入力してください')
      end
    end
  end
  describe 'showアクション' do
    it 'お題を選択すると、お題詳細ページに遷移' do
      visit(topics_path)
      selected_topic = first('.topic-item')
      selected_topic_title = selected_topic['topic-title']
      selected_topic_user_name = selected_topic['user-name']
      first('.topic-item').click
      expect(page).to have_selector('h2', text: selected_topic_title)
      expect(page).to have_selector('span', text: selected_topic_user_name)
    end
    it '自分の作成したお題には、お題を編集・削除ボタンが表示' do
      sign_in(@user)
      visit(topic_path(@topics[0]))
      expect(page).to have_button('お題を編集')
      expect(page).to have_button('お題を削除')
    end
    it '自分の作成した例えには、編集・削除ボタンが表示' do
      sign_in(@user)
      create(:answer, user_id: @user.id, topic_id: @topics[0].id)
      visit(topic_path(@topics[0]))
      expect(page).to have_button('編集')
      expect(page).to have_button('削除')
    end
    it '自分以外の例えには、「確かに！」アクションボタンが表示' do
      sign_in(@user)
      other_user = create(:user)
      other_topic = create(:topic, user_id: other_user.id)
      other_answer = create(:answer, user_id: other_user.id, topic_id: other_topic.id)
      visit(topic_path(other_topic))
      expect(page).to have_selector('h2', text: other_topic.title)
      expect(page).to have_selector('p', text: other_answer.body)
      expect(page).to have_link('確かに！')
    end
  end
  describe 'editアクション' do
    it '作成したお題に表示する「お題を編集ボタン」を押すと、お題編集ページに遷移する' do
      sign_in(@user)
      visit(topic_path(@topics[0]))
      click_button 'お題を編集'
      expect(page).to have_selector('h2', text: 'お題を編集')
      expect(page).to have_current_path(edit_topic_path(@topics[0]))
      expect(page).to have_field('お題タイトル', with: @topics[0].title)
      expect(page).to have_field('お題の説明', with: @topics[0].description)
    end
  end
  describe 'updateアクション' do
    context '正常系' do
      it '「お題を更新ボタン」を押すと、お題が更新される(ジャンルとヒントを新たに追加し、タイトルと説明を変更)' do
        sign_in(@user)
        visit(edit_topic_path(@topics[0]))
        expected_genres = [ "web開発", "例え", "バトラン" ]
        expected_hints = [ "コミュニケーションのきっかけ", "知らなかったことを学ぶことが出来る", "理解を深めることも可能" ]
        fill_in 'お題タイトル', with: 'Tatoeを別のアプリで例えると？'
        fill_in 'お題の説明', with: 'Tatoeとは一体なんなんでしょうか？他の分野で例えましょう！'
        fill_in 'お題ジャンル', with: 'web開発 例え バトラン'
        fill_in 'ヒント1', with: 'コミュニケーションのきっかけ'
        fill_in 'ヒント2', with: '知らなかったことを学ぶことが出来る'
        fill_in 'ヒント3', with: '理解を深めることも可能'
        click_button 'お題を作成'
        expect(page).to have_current_path(topic_path(@topics[0]))
        after_topic = Topic.find(@topics[0].id)
        expect(after_topic.title).to eq("Tatoeを別のアプリで例えると？")
        expect(after_topic.description).to eq("Tatoeとは一体なんなんでしょうか？他の分野で例えましょう！")
        actual_genres = after_topic.genres.map(&:name)
        expect(actual_genres.sort).to eq(expected_genres.sort)
        actual_hints = after_topic.hints.map(&:body)
        expect(actual_hints.sort).to eq(expected_hints.sort)
      end
    end
    context '異常系' do
      it 'お題が入力されていないと、エラーメッセージが表示される' do
        sign_in(@user)
        visit(edit_topic_path(@topics[0]))
        fill_in 'お題タイトル', with: ''
        click_button 'お題を作成'
        expect(page).to have_current_path(edit_topic_path(@topics[0]))
        expect(page).to have_selector('.alert-error', text: 'お題タイトルを入力してください')
      end
    end
  end
  describe 'destroyアクション' do
    it '「お題を削除ボタン」を押すと、お題が削除される' do
      sign_in(@user)
      visit(topic_path(@topics[0]))
      # click_button 'お題を削除'
      accept_confirm do
        click_button('お題を削除')
      end
      expect(page).to have_selector('.alert-info', text: 'お題を削除しました。')
      expect(Topic.exists?(@topics[0].id)).to be_falsey
    end
  end
end
