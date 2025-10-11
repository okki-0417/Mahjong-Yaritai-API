# frozen_string_literal: true

module CursorPaginationable
  def query_with_cursor_pagination(relation, cursor: nil, limit: 20)
    limit = [ limit.to_i, 100 ].min
    limit = 20 if limit <= 0

    table_name = relation.table_name

    if cursor.present?
      relation = relation.where("#{table_name}.id < ?", cursor.to_i)
    end

    records = relation.order("#{table_name}.id DESC").limit(limit + 1)

    has_next_page = records.size > limit
    records = records.first(limit) if has_next_page

    end_cursor = has_next_page ? records.last&.id : nil

    {
      edges: records,
      page_info: {
        has_next_page:,
        end_cursor:,
        limit:,
    },
    }
  end
end
