# frozen_string_literal: true

module Resolvers
  class WhatToDiscardProblemsResolver < BaseResolver
    include CursorPaginationable

    type Types::WhatToDiscardProblemType.connection_type, null: false

    argument :limit, Integer, required: false, default_value: 20
    argument :cursor, String, required: false

    def resolve(limit:, cursor:)
      relation = WhatToDiscardProblem.preload(
        :user,
        :dora,
        :hand1,
        :hand2,
        :hand3,
        :hand4,
        :hand5,
        :hand6,
        :hand7,
        :hand8,
        :hand9,
        :hand10,
        :hand11,
        :hand12,
        :hand13,
        :tsumo,
        :likes,
        :bookmarks,
        :votes,
        user: :avatar_attachment,
      )

      result = query_with_cursor_pagination(relation, cursor:, limit:)
      records = result[:records]

      {
        edges: records.map do |record|
          {
            node: record,
            cursor: record.id.to_s,
          }
        end,
        page_info: {
          has_next_page: result[:has_next],
          end_cursor: result[:next],
        },
      }
    end
  end
end
