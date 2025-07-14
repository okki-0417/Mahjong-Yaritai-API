class CustomLogger < Rails::Rack::Logger
  def call(env)
    user_agent = env["HTTP_USER_AGENT"].to_s
    request_path = env["PATH_INFO"]
    request_method = env["REQUEST_METHOD"]

    # デプロイツールからのヘルスチェックのログを出さないため
    if user_agent.include?(ENV.fetch("USER_AGENT"))
      Rails.logger.silence { super }
    # GET /sessionのログを出さないため（フロントエンドからの頻繁なアクセス）
    elsif request_method == "GET" && request_path == "/session"
      Rails.logger.silence { super }
    else
      super
    end
  end
end
