# frozen_string_literal: true

FactoryBot.define do
  factory :temp_user do
    sequence(:email) { |n| "test#{n}@mahjong-yaritai.com" }
    sequence(:token) { |n| "test#{n}_token" }
    expired_at { Time.now + 90.minutes }
  end
end
