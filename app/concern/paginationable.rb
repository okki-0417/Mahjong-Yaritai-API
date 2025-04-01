# frozen_string_literal: true

module Paginationable
  def pagination_data(pagination_records)
    {
      pagination: {
        total_pages: pagination_records.total_pages,
        current_page: pagination_records.current_page,
        prev_page: pagination_records.prev_page,
        next_page: pagination_records.next_page,
        first_page: 1,
        last_page: pagination_records.total_pages,
      }
    }
  end
end
