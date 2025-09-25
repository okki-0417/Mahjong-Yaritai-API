module Types
  class LearningQuestionType < Types::BaseObject
    field :id, ID, null: false
    field :question_text, String, null: false
    field :answer_text, String, null: true
    field :learning_category_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :learning_category, Types::LearningCategoryType, null: false
  end
end
