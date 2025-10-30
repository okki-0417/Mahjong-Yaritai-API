# frozen_string_literal: true

module Resolvers
  module Users
    class ShowResolver < BaseResolver
      graphql_name "UserShowResolver"

      type Types::UserType, null: true

      argument :id, ID, required: true

      def resolve(id:)
        User.find(id)
      end
    end
  end
end
