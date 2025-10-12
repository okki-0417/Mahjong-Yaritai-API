# frozen_string_literal: true

module Types
  class UploadType < GraphQL::Schema::Scalar
    description "Represents an uploaded file"

    def self.coerce_input(input, context)
      # Railsのmultipart parameterを処理
      # Railsのmultipart parsingによってActionDispatch::Http::UploadedFileが提供される
      raise GraphQL::CoercionError, "Expected uploaded file, got #{input.class}" unless input.is_a?(ActionDispatch::Http::UploadedFile) || input.is_a?(Rack::Test::UploadedFile)

      input
    end

    def self.coerce_result(value, context)
      # レスポンスではファイル情報を文字列として返す
      value.to_s
    end
  end
end
