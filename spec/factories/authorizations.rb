# frozen_string_literal: true

FactoryBot.define do
  factory :authorization do
    sequence(:email) { |n| "test#{n}@mahjong-yaritai.com" }
  end
end
