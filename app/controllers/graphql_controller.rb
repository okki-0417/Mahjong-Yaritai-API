# frozen_string_literal: true

class GraphqlController < ApplicationController
  def execute
    query = params[:query]
    variables = prepare_variables(params[:variables])
    operation_name = params[:operationName]

    Rails.logger.debug "=== GraphQL Controller - Before Execution ==="
    Rails.logger.debug "Operation: #{operation_name}"
    Rails.logger.debug "Session object_id: #{session.object_id}"
    Rails.logger.debug "Session: #{session.to_hash.inspect}"
    Rails.logger.debug "Cookies object_id: #{cookies.object_id}"
    Rails.logger.debug "Cookies user_id: #{cookies.signed[:user_id]}"
    Rails.logger.debug "Cookies remember_token: #{cookies.signed[:remember_token]}"

    context = { current_user:, session:, cookies: }

    result = MahjongYaritaiAppSchema.execute(query, variables:, operation_name:, context:)

    Rails.logger.debug "=== GraphQL Controller - After Execution ==="
    Rails.logger.debug "Session object_id: #{session.object_id}"
    Rails.logger.debug "Session: #{session.to_hash.inspect}"
    Rails.logger.debug "Cookies object_id: #{cookies.object_id}"
    Rails.logger.debug "Cookies user_id: #{cookies.signed[:user_id]}"
    Rails.logger.debug "Cookies remember_token: #{cookies.signed[:remember_token]}"

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: 500
  end
end
