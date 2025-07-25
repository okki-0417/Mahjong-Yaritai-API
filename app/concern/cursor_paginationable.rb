# frozen_string_literal: true

module CursorPaginationable
  def cursor_paginate(relation, cursor: nil, limit: 20)
    limit = [ limit.to_i, 100 ].min
    limit = 20 if limit <= 0

    table_name = relation.table_name

    if cursor.present?
      relation = relation.where("#{table_name}.id < ?", cursor.to_i)
    end

    records = relation.order("#{table_name}.id DESC").limit(limit + 1)

    has_next = records.size > limit
    records = records.first(limit) if has_next

    next_cursor = has_next ? records.last&.id : nil

    {
      records: records,
      meta: {
        cursor: {
          next: next_cursor,
          has_next: has_next,
          limit:,
        },
      },
    }
  end
end
