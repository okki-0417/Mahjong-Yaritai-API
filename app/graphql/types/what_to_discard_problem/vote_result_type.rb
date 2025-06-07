# frozen_string_literal: true

module Types::WhatToDiscardProblem
  class VoteResultType < Types::BaseObject
    field :tile_id, Int, null: false
    field :count, Int, null: false
  end
end
