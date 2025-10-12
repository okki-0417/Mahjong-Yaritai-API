# frozen_string_literal: true

module Resolvers
  module Users
    class ShowResolver < BaseResolver
      type Types::UserType, null: true
      description "Get a user by ID"

      argument :id, ID, required: true

      def resolve(id:)
        User.find_by(id: id)
      end
    end
  end
end
