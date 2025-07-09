# frozen_string_literal: true

class WhatToDiscardProblem::Vote::ResultSerializer < ActiveModel::Serializer
  attributes %i[
    tile_id
    count
    is_voted_by_me
  ]

  def tile_id
    object&.[](:tile_id)
  end

  def count
    object&.[](:count)
  end

  def is_voted_by_me
    object&.[](:is_voted_by_me)
  end
end
