# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "テストユーザー#{n}" }
    sequence(:email) { |n| "testuser#{n}@test#{n}.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
