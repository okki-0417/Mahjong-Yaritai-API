# frozen_string_literal: true

module Types
  class MetaType < Types::BaseObject
    field :pagination, Types::Meta::PaginationType
  end
end
