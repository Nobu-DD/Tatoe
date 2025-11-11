class OgpCreatorService
  require "mini_magick"

  BASE_IMAGE_PATH = "./app/assets/images/Tatoe_OGP.png"
  FONT = "./app/assets/fonts/Noto_Sans_JP/static/NotoSansJP-ExtraBold.ttf"
  ROW_LIMIT = 2

  def self.topic_build(topic_title)
    topic_text = prepare_main_text(topic_title)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      # お題タイトル
      config.fill "#03B4F3"
      config.font FONT
      config.gravity "center"
      config.pointsize 65
      config.draw "text 0,0 '#{topic_text}'"
      image.format "png"
    end
    png_data = image.to_blob
    filename = "ogp_image.png"
    io = StringIO.new(png_data)
    io.define_singleton_method(:original_filename) { filename }
    io.define_singleton_method(:content_type) { "image/png" }

    io
  end

  def self.answer_build(topic, answer)
    topic_text = prepare_head_text(topic.title)
    answer_text = prepare_main_text(answer.body)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      # 基本設定
      config.font FONT
      # お題タイトル
      config.fill "#65cff2"
      config.gravity "north"
      config.pointsize 50
      config.draw "text 0,50 '#{topic_text}'"
      # 例え内容
      config.fill "#03B4F3"
      config.gravity "center"
      config.pointsize 65
      config.draw "text 0,0 '#{answer_text}'"
    end
    image.format "png"
    png_data = image.to_blob
    filename = "ogp_image.png"
    io = StringIO.new(png_data)
    io.define_singleton_method(:original_filename) { filename }
    io.define_singleton_method(:content_type) { "image/png" }

    io
  end

  def self.x_share_encode(object)
    if object.is_a?(Topic)
      message = "『#{object.title}』を投稿しました！例えてみてください！"
      url = "https://tatoe.net/topics/#{object.id}"
      genres = object.genres.limit(5).map { |genre| "##{genre.name}" }.join(" ")
    else
      message = "『#{object.body}』を投稿しました！コメントをしてみましょう！"
      url = "https://tatoe.net/topics/#{object.topic_id}/answers/#{object.id}"
      genres = object.topic.genres.limit(5).map { |genre| "##{genre.name}" }.join(" ")
    end
    encode_text = URI.encode_www_form_component("#{message} #{genres}")
    "https://twitter.com/share?text=#{encode_text}&url=#{url}"
  end

  private

  def self.prepare_head_text(text)
    text.scan(/.{1,#{21}}/)[0...ROW_LIMIT].join("\n")
  end

  def self.prepare_main_text(text)
    text.scan(/.{1,#{17}}/)[0...ROW_LIMIT].join("\n")
  end
end
