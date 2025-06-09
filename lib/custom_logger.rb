class CustomLogger < Rails::Rack::Logger
  def call(env)
    user_agent = env["HTTP_USER_AGENT"].to_s

    if user_agent.include?(ENV.fetch("USER_AGENT"))
      Rails.logger.silence { super }
    else
      super
    end
  end
end
