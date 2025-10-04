class OgpImagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show_topic]
  def show_topic
    topic = Topic.find(params[:id])
    image = OgpCreatorService.build(topic.title).tempfile.open.read
    send_data image, type: "image/png", disposition: "inline"
  end
end
