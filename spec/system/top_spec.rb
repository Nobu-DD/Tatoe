require 'rails_helper'

RSpec.describe "Top", type: :system do
  describe 'indexアクション' do
    before do
      @user = create(:user)
      @topic = build(:topic)
      @topic.user_id = @user.id
      @topic.save
      @pickup = build(:pickup)
      @pickup.topic_id = @topic.id
      visit(root_path)
    end
    it '左上のロゴを選択すると、トップページに遷移する' do
      visit(topics_path)
      click_link('Tatoeロゴ')
      expect(page).to have_current_path(root_path)
    end
    it 'ピックアップが期間内に設定されていたら表示させる' do
      @pickup.save
      visit current_path
      expect(page).to have_content("#{I18n.l(@pickup.start_at, format: :pickup)}〜#{I18n.l(@pickup.end_at, format: :pickup)}")
      expect(page).to have_content(@topic.title)
      expect(page).to have_content(@user.name)
      expect(page).to have_link("例えを投稿！")
    end
    it 'ピックアップ対象が無ければコメントを表示させる' do
      expect(page).to have_selector('h4', text: "現在ピックアップは設定されていません")
      expect(page).to have_selector('p', text: "特別なお題を準備中です！ 近日公開予定！楽しみにお待ちください！🎉")
    end
    it '「最近のお題」は登録が新しい順に表示させる' do
      # 作成していたお題を一旦削除
      @topic.delete
      # お題を5件ほど新規作成する
      @topics = create_list(:topic, 5, user_id: @user.id)
      # sort_byでtopicのpublished_atを対象にして昇順に並び替え。reverseで昇順から降順に切り替え、mapでidのみを抽出して配列格納
      expected_datetimes = @topics.sort_by { |topic| topic.published_at }.reverse.map{|topic| I18n.l(topic.published_at)}
        # I18n.l(topic.published_at, format: :long)
      # 一覧ページを更新する
      visit(current_path)
      # erbから例えの要素を配列として格納。topicのdivをtopic-itemクラスとして定義
      actual_datetimes = all('.published-at').map(&:text)
      # 一覧として表示されているお題の順番が"降順"になっているか検証
      expect(actual_datetimes).to eq(expected_datetimes)
    end
  end
end
