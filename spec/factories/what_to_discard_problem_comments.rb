# frozen_string_literal: true

FactoryBot.define do
  factory :what_to_discard_problem_comment do
    association :user, factory: :user
    association :what_to_discard_problem, factory: :what_to_discard_problem
    reply_to_comment_id { nil }
    content { "test content" }
  end
end
