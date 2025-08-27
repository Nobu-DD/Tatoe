require 'rails_helper'

RSpec.describe "AnswersReactions", type: :system do
  before do
    @user = create(:user)
    sign_in(@user)
    @other_user = create(:user)
    @other_topic = create(:topic, user_id: @other_user.id)
    @other_answer = create(:answer, user_id: @other_user.id, topic_id: @other_topic.id)
    @reaction = create(:reaction)
  end
  describe 'createアクション' do
    context '正常系' do
      it 'お題詳細ページの例えにある確かにボタンを押すと、お気に入りを表示できる' do
        # 他の方の例えが投稿されているお題に遷移
        visit(topic_path(@other_topic))
        expect(page).to have_current_path(topic_path(@other_topic))
        # まず、検証対象のボタン要素(ブラウザ側)を特定し、svgを取得
        before_svg_element = find("#answer_reaction_answer_#{@other_answer.id}_reaction_#{@reaction.id} svg")
        # svgのclassタグを指定し、ブラウザのsvgクラス内にfill-red-500とstroke-red-500が存在しないことを検証
        expect(before_svg_element[:class]).to_not include('fill-red-500', 'stroke-red-500')
        click_link('確かに！')
        # ボタンを押した後のsvgを取得
        after_svg_element = find("#unanswer_reaction_answer_#{@other_answer.id}_reaction_#{@reaction.id} svg")
        # svgのclassタグを指定し、ブラウザのsvgクラス内にfill-red-500とstroke-red-500が存在することを検証
        expect(after_svg_element[:class]).to include('fill-red-500', 'stroke-red-500')
      end
      it '確かにボタンを押すと、お気に入りを解除できる' do
        AnswerReaction.create(user_id: @user.id, answer_id: @other_answer.id, reaction_id: @reaction.id)
        visit(topic_path(@other_topic))
        before_svg_element = find("#unanswer_reaction_answer_#{@other_answer.id}_reaction_#{@reaction.id} svg")
        expect(before_svg_element[:class]).to include('fill-red-500', 'stroke-red-500')
        click_link('確かに！')
        after_svg_element = find("#answer_reaction_answer_#{@other_answer.id}_reaction_#{@reaction.id} svg")
        expect(after_svg_element[:class]).to_not include('fill-red-500', 'stroke-red-500')
      end
    end
  end
end
