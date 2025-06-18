# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :what_to_discard_problems, resolver: Resolvers::WhatToDiscardProblemsResolver, connection: false
    field :what_to_discard_problem_vote_result, resolver: Resolvers::WhatToDiscardProblems::VoteResultResolver,
connection: false
  end
end
