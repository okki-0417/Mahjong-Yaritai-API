# frozen_string_literal: true

class WhatToDiscardProblem::Vote < ApplicationRecord
  belongs_to :user
  belongs_to :what_to_discard_problem
  belongs_to :tile

  validates :user_id, uniqueness: { scope: :what_to_discard_problem }
end
