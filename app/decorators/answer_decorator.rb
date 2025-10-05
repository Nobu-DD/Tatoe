class AnswerDecorator < Draper::Decorator
  delegate_all

  def x_share_encode
    message = 
    genres = object.topic.genres.limit(5).map { |genre| "##{genre.name}" }.join(" ")
    # 画像OGPのメタデータを格納したURLを設定する
    url = "https://tatoe.net/topics/#{object.id}"

    encode_text = URI.encode_www_form_component("#{message} #{genres}")
    "https://twitter.com/share?text=#{encode_text}&url=#{url}"
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
