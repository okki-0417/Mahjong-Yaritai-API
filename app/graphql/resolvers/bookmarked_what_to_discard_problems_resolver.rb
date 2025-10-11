# frozen_string_literal: true

module Resolvers
  class BookmarkedWhatToDiscardProblemsResolver < BaseResolver
    type Types::WhatToDiscardProblemType.connection_type, null: false
    description "Get bookmarked what to discard problems with cursor pagination"

    argument :limit, Integer, required: false, default_value: 20
    argument :cursor, String, required: false

    def resolve(limit: 20, cursor: nil)
      return { edges: [], page_info: { has_next_page: false, end_cursor: nil } } unless current_user

      limit = [ limit.to_i, 100 ].min
      limit = 20 if limit <= 0

      # ユーザーのブックマークを取得（ポリモーフィック関連を利用）
      # 牌とその他の関連を効率的にpreload
      bookmarks = current_user.created_bookmarks
        .where(bookmarkable_type: "WhatToDiscardProblem")
        .includes(bookmarkable: [
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
        ])

      if cursor.present?
        bookmarks = bookmarks.where("bookmarks.id < ?", cursor.to_i)
      end

      bookmarks = bookmarks.order(id: :desc).limit(limit + 1)

      has_next_page = bookmarks.size > limit
      bookmarks = bookmarks.first(limit) if has_next_page

      end_cursor = has_next_page ? bookmarks.last&.id&.to_s : nil

      {
        edges: bookmarks.map do |bookmark|
          {
            node: bookmark.bookmarkable,
            cursor: bookmark.id.to_s,
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
