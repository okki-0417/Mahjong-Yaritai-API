# frozen_string_literal: true

module Types
  class UploadType < GraphQL::Schema::Scalar
    description "Represents an uploaded file"

    def self.coerce_input(input, context)
      # Railsのmultipart parameterを処理
      # Railsのmultipart parsingによってActionDispatch::Http::UploadedFileが提供される
      if input.is_a?(ActionDispatch::Http::UploadedFile) || input.is_a?(Rack::Test::UploadedFile)
        input
      else
        raise GraphQL::CoercionError, "Expected uploaded file, got #{input.class}"
      end
    end

    def self.coerce_result(value, context)
      # レスポンスではファイル情報を文字列として返す
      value.to_s
    end
  end
end