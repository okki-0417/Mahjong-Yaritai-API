# frozen_string_literal: true

module Types
  class WhatToDiscardProblemConnectionType < Types::BaseObject
    field :edges, [ Types::WhatToDiscardProblemEdgeType ], null: false
    field :page_info, Types::PageInfoType, null: false
  end
end
