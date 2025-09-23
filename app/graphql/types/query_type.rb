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

    field :current_session, Types::SessionType, null: false,
      description: "Get current user session"

    def current_session
      {
        is_logged_in: context[:current_user].present?,
        user_id: context[:current_user]&.id,
        user: context[:current_user],
      }
    end

    field :user, Types::UserType, null: true,
      description: "Get user by ID" do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find_by(id: id)
    end

    field :what_to_discard_problems, Types::WhatToDiscardProblemConnectionType, null: false,
      description: "Get what to discard problems with cursor pagination",
      connection: false do
      argument :limit, Integer, required: false, default_value: 20
      argument :cursor, String, required: false
    end

    def what_to_discard_problems(limit: 20, cursor: nil)
      limit = [ limit.to_i, 100 ].min
      limit = 20 if limit <= 0

      relation = WhatToDiscardProblem.preload(user: :avatar_attachment)

      if cursor.present?
        relation = relation.where("what_to_discard_problems.id < ?", cursor.to_i)
      end

      records = relation.order(id: :desc).limit(limit + 1)

      has_next_page = records.size > limit
      records = records.first(limit) if has_next_page

      end_cursor = has_next_page ? records.last&.id&.to_s : nil

      {
        edges: records.map do |record|
          {
            node: record,
            cursor: record.id.to_s,
          }
        end,
        page_info: {
          has_next_page: has_next_page,
          end_cursor: end_cursor,
        },
      }
    end
  end
end
