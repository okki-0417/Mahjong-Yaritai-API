# frozen_string_literal: true

FactoryBot.define do
  factory :auth_request, class: 'Auth::Request' do
    sequence(:email) { |n| "test#{n}@mahjong-yaritai.com" }
  end
end
