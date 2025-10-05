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
    end
  end

  def self.answer_build(topic_title, answer_body)
    topic_text = prepare_head_text(topic_title)
    answer_text = prepare_main_text(answer_body)
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
  end

  private

  def self.prepare_head_text(text)
    text.scan(/.{1,#{21}}/)[0...ROW_LIMIT].join("\n")
  end

  def self.prepare_main_text(text)
    text.scan(/.{1,#{17}}/)[0...ROW_LIMIT].join("\n")
  end
end
