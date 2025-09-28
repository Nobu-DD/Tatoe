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
    binding.pry
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

  def answer_request_body
    topic = @params[:topic]
    hints_text = topic[:hints].present? ? topic[:hints].join('、') : "ヒントなし"
  {
    systemInstruction: {
      parts: [{
        text: "あなたは、指定したお題に対してユニークな「例え」を生み出すことが出来る専門家です。お題に対して単体、もしくは複数の「例えるテーマ」を与えるので、誰もがその例えを見た時に「わかりやすい！」「面白い例え！」と思わせるような例えを理由も含めて提案してください。出力は、厳密に指定されたJSONスキーマに従ってください。なお、「例えるテーマ」が与えられなかった場合、指定しているフォーマットを参考にして、自由に作成してください。"
      }],
      role: "model"
    },
    contents: [{
      parts: [{
        text: <<~PROMPT
        まずは以下のフォーマットに従ってbodyとreasonを出力してください。

        入力例:
        お題タイトル: 競馬の日本ダービーを他のスポーツで例えると？
        お題の説明: 若駒達の頂点を決めるレース、日本ダービー。競馬初心者でもわかりやすい例えを考えてみましょう！
        例えを出すヒント: 一生に一回しか出られない、3歳という若い馬齢の時、同世代でトップを決めるレース
        例えるテーマ: 野球
        出力例:
        body: 高校野球の甲子園決勝
        reason: 高校生という限られた年齢のみ甲子園の資格が得られる。そして高校生同士という世代が近い者たちが日本一を目指して試合に取り組む姿が日本ダービーに似ているなと感じました。

        入力:
        お題タイトル: #{topic[:title]}
        お題の説明: #{topic[:description]}
        例えを出すヒント: #{hints_text}
        例えるテーマ: #{@params[:theme]}
        出力:
        body: 例えるテーマを元に例えを生成してください。何も書かれていない場合、自由に例えてみてください。
        reason: なぜその例え方をしたのか、理由を50文字前後で説明してください。
        PROMPT
      }],
      role: "user"
    }],

    generationConfig: {
      responseMimeType: "application/json",
      responseSchema: {
        type: "object",
        properties: {
          body: { type: "string" },
          reason: { type: "string" }
        }
      },
      required: [ "body", "reason" ]
    }
  }.to_json
  end
end
