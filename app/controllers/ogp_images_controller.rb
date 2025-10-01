class OgpImagesController < ApplicationController
  def show_topic
    # topic = Topic.find(params[:id])
    topic = Topic.find(params[:id])
    image = OgpCreatorService.build(topic.title).tempfile.open.read
    send_data image, type: "image/png", disposition: "inline"
  end
end