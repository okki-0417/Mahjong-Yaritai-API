# frozen_string_literal: true

module Resolvers
  module Sessions
    class ShowSession < BaseResolver
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
end
