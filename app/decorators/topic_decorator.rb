class TopicDecorator < Draper::Decorator
  delegate_all

  def topic_json_data
    {
      title: object.title,
      description: object.description,
      hints: object.hints.map(&:body)
    }.to_json
  end

  def x_share_encode
    message = "お題を投稿しました！例えてみてください！"
    genres = object.genres.limit(5).map { |genre| "##{genre.name}" }.join(' ')
    url = "https://tatoe.net/topics/#{object.id.to_s}"

    encode_text = URI.encode_www_form_component("#{message} #{genres}")
    return "https://twitter.com/share?text=#{encode_text}&url=#{url}"
  end
end
