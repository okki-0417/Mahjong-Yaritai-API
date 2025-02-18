# frozen_string_literal: true

FactoryBot.define do
  factory :what_to_discard_problem_like, class: "WhatToDiscardProblem::Like" do
    association :user
    association :what_to_discard_problem
  end
end
