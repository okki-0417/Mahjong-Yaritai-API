# frozen_string_literal: true

module Types
  class BookmarkType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: false
    field :problem_id, ID, null: false, method: :bookmarkable_id
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
