class GeminiApiService
  def initialize(genre)
    # ユーザーが入力したプロントの文字列を渡す引数
    @genre = genre
  end

  def run
    http_request = prepare_http_request
    http_request[:request].body = request_body
    response = http_request[:http].request(http_request[:request])

    raise "Gemini: response is not success" unless response.is_a?(Net::HTTPResponse)
    parsed_response = JSON.parse(response.body)
    text_content = parsed_response.dig("candidates", 0, "content", "parts", 0, "text")
    return text_content
  end

  private

  def prepare_http_request
    # geminiApiのエンドポイント先を指定(Gemini 2.5 Flash-Lite)
    endpoint = "https://generativelanguage.googleapis.com/v1beta/models/#{Rails.application.config.gemini_api[:default_model]}:generateContent"
    # エンドポイントにapiキークエリパラメータとして追加後URLに変換
    url = URI.parse("#{endpoint}?key=#{Rails.application.config.gemini_api[:api_key]}")
    # host名("generativelanguage.googleapis.com")とポート番号("443")を指定してHTTPの送受信を扱うクラスを作成
    http = Net::HTTP.new(url.host, url.port)
    # https(暗号化プロコトル)を使用するため、必ずsslをtrueに設定
    http.use_ssl = true
    # HTTP::POSTクラスを新規作成して、POSTメソッドのリクエストを作成する。内容はJSON形式。
    request = Net::HTTP::Post.new(url, { "Content-Type" => "application/json" })
    # geminiapiのHTTPクラスとJSON形式が含まれているHTTP:POSTクラスをハッシュに格納してメソッドの返り値とする。
    { http:, request: }
  end

  def request_body
    {
      systemInstruction: {
        parts: [{
          text: "あなたは、ユーザーから与えられたジャンルに関する、ユニークで面白い「例え」のお題を生成する専門家です。ジャンルを提示するので、一般的な例えではなく、意外性があり、思考を深めるようなお題を1行で生成してください。"
        }],
        role: "model"
      },
      contents: [{
        parts: [{
          text: @genre
        }],
        role: "user"
      }],
    }.to_json
  end
end
