Rails.application.config.gemini_api = {
  api_key: ENV["GEMINI_API_KEY"],
  default_model: "gemini-2.5-flash-lite"
}

# OpenAI.configure do |config|
#   config.access_token = Rails.application.config.openai[:api_key]
#   config.log_errors = Rails.env.development?
# end