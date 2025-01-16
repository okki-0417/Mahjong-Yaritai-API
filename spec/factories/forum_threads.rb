# frozen_string_literal: true

FactoryBot.define do
  factory :forum_thread do
    sequence(:topic) { |n| "テストスレッド#{n}" }
    association :created_user, factory: :user
  end
end
