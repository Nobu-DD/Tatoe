class OgpCreatorService
  require "mini_magick"

  BASE_IMAGE_PATH = "./app/assets/images/Tatoe_OGP.png"
  FONT = "./app/assets/fonts/Noto_Sans_JP/static/NotoSansJP-Bold.ttf"
  GRAVITY = "center"
  TEXT_POSITION = "0,0"
  TEXT_COLOR = "white"
  FONT_SIZE = 65
  INDENTION_COUNT = 15
  ROW_LIMIT = 3

  def self.build(text)
    text = prepare_text(text)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      config.fill TEXT_COLOR
      config.font FONT
      config.gravity GRAVITY
      config.pointsize FONT_SIZE
      config.draw "text #{TEXT_POSITION} '#{text}'"
    end
  end

  private

  def self.prepare_text(text)
    text.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end