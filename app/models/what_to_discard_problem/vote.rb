# frozen_string_literal: true

class WhatToDiscardProblem::Vote < ApplicationRecord
  belongs_to :user
  belongs_to :what_to_discard_problem, counter_cache: true
  belongs_to :tile

  validates :user_id, uniqueness: { scope: :what_to_discard_problem }
end
