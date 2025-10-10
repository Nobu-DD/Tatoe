class TopicDecorator < Draper::Decorator
  delegate_all

  def topic_json_data
    {
      id: object.id,
      title: object.title,
      description: object.description,
      hints: object.hints.map(&:body)
    }.to_json
  end

  private

  # def set_meta_tags


  #   load_meta_tags
  #     og: {
  #       title: object.title,
  #       description: object.description,
  #       type: "website",
  #       url: "https://tatoe.net/topics/#{object.id}"
  #       image: image_url,

  #     },
  #     twitter: {

  #     }
  # end
end
