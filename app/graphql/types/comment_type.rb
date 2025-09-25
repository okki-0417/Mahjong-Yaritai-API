# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :user_id, ID, null: false
    field :parent_comment_id, ID, null: true
    field :replies_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :user, Types::UserType, null: false
    def user
      object.user
    end

    field :replies, [Types::CommentType], null: false do
      argument :limit, Integer, required: false
      argument :cursor, String, required: false
    end

    def replies(limit: 10, cursor: nil)
      scope = object.class.where(parent_comment_id: object.id)
      scope = scope.where("id > ?", cursor) if cursor
      scope.limit(limit).includes(:user)
    end
  end
end