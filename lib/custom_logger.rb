# frozen_string_literal: true

class CustomLogger < ActiveSupport::Logger
  HEALTH_CHECK_PATHS = %w[/up /].freeze

  # ActiveSupport::Logger の add メソッドをオーバーライド
  def add(severity, message = nil, program_name = nil, &block)
    return true if should_silence?(message, &block)

    super
  end

  private

  def should_silence?(message, &block)
    # Health check のログがノイズだったため
    return true if health_check_request?(message)

    if block_given?
      evaluated_message = block.call
      return true if health_check_request?(evaluated_message)
    end

    false
  end

  def health_check_request?(message)
    # 暫定対応として Rails::HealthController のログメッセージから判定
    return false unless message.is_a?(String)
    return true if message.include?("Rails::HealthController")

    HEALTH_CHECK_PATHS.any? do |path|
      message.include?("\"#{path}\"") ||
        message.include?("path=\"#{path}\"") ||
        message.match?(/\s#{Regexp.escape(path)}\s/) ||
        message.match?(/^Processing.*#{Regexp.escape(path)}/) ||
        message.match?(/^Completed.*#{Regexp.escape(path)}/)
    end
  end
end
