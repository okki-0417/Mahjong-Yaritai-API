# frozen_string_literal: true

module Resolvers
  class SessionResolver < BaseResolver
    graphql_name "CurrentSessionResolver"

    include Authenticatable

    type Types::SessionType, null: false

    def resolve
      {
        is_logged_in: logged_in?,
        user: current_user,
      }
    end
  end
end
