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
    genres = object.genres.map{|genre| "#" + genre}.join(' ')
    url = "https://tatoe.net/topics/#{object.id}"

    return URI.encode_www_form_component('#{message} #{genres} #{url}')
  end
end
