class OgpImagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show_topic]
  def show_topic
    topic = Topic.find(params[:id])
    image = OgpCreatorService.topic_build(topic.title).tempfile.open.read
    send_data image, type: "image/png", disposition: "inline"
  end

  def show_answer
    topic = Topic.includes(:answers).find(params[:topic_id])
    answer = topic.answers.find { |answer| answer.id == params[:answer_id] }
    image = OgpCreatorService.answer_build(topic.title, answer.body)
  end
end
