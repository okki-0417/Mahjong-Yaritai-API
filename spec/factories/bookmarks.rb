# frozen_string_literal: true

FactoryBot.define do
  factory :bookmark do
    association :user
    association :bookmarkable, factory: :what_to_discard_problem
  end
end
