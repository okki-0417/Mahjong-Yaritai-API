# frozen_string_literal: true

module Types
  class WhatToDiscardProblemsConnectionType < Types::BaseObject
    field :data, [Types::WhatToDiscardProblemType], null: false
    field :meta, Types::MetaType, null: false
  end
end
