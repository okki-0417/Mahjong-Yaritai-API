# frozen_string_literal: true

FactoryBot.define do
  factory :mahjong_session do
    total_game_fee { 0 }
    association :creator_user, factory: :user
    association :mahjong_scoring_setting
  end
end
