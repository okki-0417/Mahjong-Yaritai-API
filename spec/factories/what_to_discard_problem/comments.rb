# frozen_string_literal: true

FactoryBot.define do
  factory :what_to_discard_problem_comment, class: "WhatToDiscardProblem::Comment" do
    association :user
    association :what_to_discard_problem
    parent_comment_id { nil }
    content { "test content" }
  end
end
