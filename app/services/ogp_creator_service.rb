class OgpCreatorService
  require "mini_magick"

  BASE_IMAGE_PATH = "./app/assets/images/Tatoe_OGP.png"
  FONT = "./app/assets/fonts/Noto_Sans_JP/static/NotoSansJP-Bold.ttf"
  TEXT_POSITION = "0,0"
  TEXT_COLOR = "white"
  INDENTION_COUNT = 15
  ROW_LIMIT = 3

  def self.topic_build(topic_title)
    topic_text = prepare_text(topic_title)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      # お題タイトル
      config.fill TEXT_COLOR
      config.font FONT
      config.gravity "center"
      config.pointsize 65
      config.draw "text #{TEXT_POSITION} '#{topic_text}'"
    end
  end

  def self.answer_build(topic_title, answer_body)
    topic_text, answer_text = [topic_title, answer_body].map{ |text| prepare_text(text) }
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      # お題タイトル
      config.fill TEXT_COLOR
      config.font FONT
      config.gravity "north"
      config.pointsize 50
      config.draw "text #{TEXT_POSITION} '#{topic_text}'"
       # 例え内容
      config.fill TEXT_COLOR
      config.font FONT
      config.gravity "center"
      config.pointsize 65
      config.draw "text #{TEXT_POSITION} '#{answer_text}'"
    end
  end

  private

  def self.prepare_text(text)
    text.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end
