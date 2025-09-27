class GeminiGenerationService
  def initialize(type, params = {})
    # ユーザーが入力したプロントの文字列を渡す引数
    @type = type
    @params = params
  end

  def run
    http_request = prepare_http_request
    http_request[:request].body = request_body
    response = http_request[:http].request(http_request[:request])
    parsed_response = JSON.parse(response.body)
    text_content = parsed_response.dig("candidates", 0, "content", "parts", 0, "text")

    text_content
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
    case @type
    when :topic then topic_request_body
    when :answer then answer_request_body
    end
  end

  def topic_request_body
    {
      systemInstruction: {
        parts: [ {
          text: "あなたは、ユーザーから与えられた2つの要素(ジャンルと例えの分野)を組み合わせて、ユニークな「例え」の問いかけを生成する専門家です。ユーザーの想像力を刺激し、議論を深めるような、面白くて意外性のある問いかけを1つ提案してください。出力は、厳密に指定されたJSONスキーマに従ってください。なお、入力されていない要素があった場合、指定しているフォーマットを参考にして、自由に作成してください"
        } ],
        role: "model"
      },
      contents: [ {
        parts: [ {
          text: <<~PROMPT
          まずは以下のフォーマットに従ってtitleを出力してください。

          入力:
          ジャンル: 競馬
          例えてほしい内容: 他のスポーツ

          出力:
          競馬の日本ダービーをサッカーの大会で例えると？

          入力:
          ジャンル: 手芸
          例えてほしい内容: ブルーカラーの職業

          出力:
          手芸の刺繍を土方の業務で例えると？

          入力:
          ジャンル: #{@params[:genre]}
          例えてほしい内容: #{@params[:compare]}

          出力:
          title: [キーワード]の[キーワード]を[キーワード]で例えると？
          description: 生成した:titleの意図を簡潔に説明してください。少し柔らかい表現で出力してください。
          genres: ユーザーが提示した「#{@params[:genre]}」と「#{@params[:compare]}」の2つのキーワードと、:titleに関連したジャンル名を配列として5つ以内に含めてください。
          hints: :titleに対して例えやすくなるように、ヒントを3つ箇条書きで提供してください。1つのヒントにつき30文字前後で出力してください。
          PROMPT
        } ],
        role: "user"
      } ],
      generationConfig: {
        responseMimeType: "application/json",
        responseSchema: {
          type: "object",
          properties: {
            title: { type: "string" },
            description: { type: "string" },
            genres: {
              type: "array",
              items: { type: "string" }
            },
            hints: {
              type: "object",
              properties: {
                hint_1: { type: "string" },
                hint_2: { type: "string" },
                hint_3: { type: "string" }
              }
            }
          },
          required: [ "title", "description", "genres", "hints" ]
        }
      }
    }.to_json
  end
end
