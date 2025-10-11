# frozen_string_literal: true

module Resolvers
  class LearningCategoryResolver < BaseResolver
    type Types::LearningCategoryType, null: true
    description "Get learning category by ID"

    argument :id, ID, required: true

    def resolve(id:)
      LearningCategory.includes(:learning_questions).find_by(id: id)
    end
  end
end
