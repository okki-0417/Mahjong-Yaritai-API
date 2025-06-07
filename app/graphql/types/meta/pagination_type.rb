# frozen_string_literal: true

module Types::Meta
  class PaginationType < Types::BaseObject
    field :total_pages, Integer
    field :current_page, Integer
    field :prev_page, Integer
    field :next_page, Integer
    field :first_page, Integer
    field :last_page, Integer
  end
end
