class TopicDecorator < Draper::Decorator
  delegate_all

  def topic_json_data
    {
      title: object.title,
      description: object.description,
      hints: object.hints.map(&:body)
    }.to_json
  end

  def x_share_encode(type)
    message = type == "topic" ? "お題を投稿しました！例えてみてください！" : "例えを投稿しました！コメントをしてみましょう！"
    genres = object.genres.limit(5).map { |genre| "##{genre.name}" }.join(" ")
    # 画像OGPのメタデータを格納したURLを設定する
    url = "https://tatoe.net/topics/#{object.id}"

    encode_text = URI.encode_www_form_component("#{message} #{genres}")
    "https://twitter.com/share?text=#{encode_text}&url=#{url}"
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
