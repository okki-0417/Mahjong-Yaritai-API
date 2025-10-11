# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :current_session, resolver: Resolvers::SessionResolver
    field :user, resolver: Resolvers::UserResolver
    field :what_to_discard_problem, resolver: Resolvers::WhatToDiscardProblemResolver
    field :what_to_discard_problems, resolver: Resolvers::WhatToDiscardProblemsResolver
    field :learning_categories, resolver: Resolvers::LearningCategoriesResolver
    field :learning_category, resolver: Resolvers::LearningCategoryResolver
    field :learning_questions, resolver: Resolvers::LearningQuestionsResolver
    field :bookmarked_what_to_discard_problems, resolver: Resolvers::BookmarkedWhatToDiscardProblemsResolver
    field :followed_users, resolver: Resolvers::FollowedUsersResolver
    field :followers, resolver: Resolvers::FollowersResolver
  end
end
