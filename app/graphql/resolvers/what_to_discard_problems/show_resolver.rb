# frozen_string_literal: true

module Resolvers
  module WhatToDiscardProblems
    class ShowResolver < BaseResolver
      graphql_name "WhatToDiscardProblemShowResolver"

      type Types::WhatToDiscardProblemType, null: true
      description "Get a single what to discard problem by ID"

      argument :id, ID, required: true

      def resolve(id:)
        WhatToDiscardProblem.find(id)
      end
    end
  end
end
