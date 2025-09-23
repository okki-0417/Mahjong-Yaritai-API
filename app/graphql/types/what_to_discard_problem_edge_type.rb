# frozen_string_literal: true

module Types
  class WhatToDiscardProblemEdgeType < Types::BaseObject
    field :node, Types::WhatToDiscardProblemType, null: false
    field :cursor, String, null: false
  end
end
