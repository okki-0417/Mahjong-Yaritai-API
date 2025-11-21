# frozen_string_literal: true

class CustomLogger < ActiveSupport::Logger
  HEALTH_CHECK_PATHS = %w[/up /].freeze

  # ActiveSupport::Logger の add メソッドをオーバーライド
  def add(severity, message = nil, progname = nil, &block)
    return true if should_silence?(message, &block)

    super
  end

  private

  def should_silence?(message, &block)
    return true if message.is_a?(String) && health_check_request?(message)

    if block_given?
      evaluated_message = block.call
      return true if evaluated_message.is_a?(String) && health_check_request?(evaluated_message)
    end

    false
  end

  def health_check_request?(message)
    HEALTH_CHECK_PATHS.any? do |path|
      message.include?("\"#{path}\"") || message.include?("Rails::HealthController")
    end
  end
end
