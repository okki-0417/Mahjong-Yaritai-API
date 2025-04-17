# frozen_string_literal: true

FactoryBot.define do
  factory :tile do
    suit { "manzu" }
    ordinal_number_in_suit { 1 }
    name { "一筒" }
  end
end
