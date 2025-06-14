# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s
  config.openapi_format = :yaml

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "API V1",
        version: "v1"
      },
      paths: {},
      servers: [
        {
          url: "http://murai.local:3001",
        }
      ],
      components: {
        schemas: {
          Like: {
            type: :object,
            required: %w[id user_id what_to_discard_problem_id created_at updated_at],
            properties: {
              id: { type: :integer },
              user_id: { type: :integer },
              what_to_discard_problem_id: { type: :integer },
              created_at: { type: :string, format: :date_time },
              updated_at: { type: :string, format: :date_time }
            }
          },
          Comment: {
            type: :object,
            required: %w[id user_id what_to_discard_problem_id created_at updated_at],
          }
        }
      }
    }
  }
end
