# frozen_string_literal: true

class WhatToDiscardProblem::Like < ApplicationRecord
  belongs_to :user
  belongs_to :what_to_discard_problem

  validates :user_id, uniqueness: { scope: :what_to_discard_problem_id }
end
