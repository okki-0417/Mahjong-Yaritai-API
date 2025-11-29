# frozen_string_literal: true

FactoryBot.define do
  factory :mahjong_participant do
    association :mahjong_session
    association :user
    name { "参加者#{SecureRandom.hex(4)}" }
  end
end
