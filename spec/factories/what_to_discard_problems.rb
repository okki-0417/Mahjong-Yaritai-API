# frozen_string_literal: true

FactoryBot.define do
  factory :what_to_discard_problem do
    association :user, factory: :user
    round { "東一" }
    turn  { 2 }
    wind  { "東" }
    dora  { 1 }
    point_east { 250 }
    point_south { 250 }
    point_west { 250 }
    point_north { 250 }
    hand1 { 1 }
    hand2 { 2 }
    hand3 { 3 }
    hand4 { 4 }
    hand5 { 5 }
    hand6 { 6 }
    hand7 { 7 }
    hand8 { 8 }
    hand9 { 9 }
    hand10 { 10 }
    hand11 { 11 }
    hand12 { 12 }
    hand13 { 13 }
    tsumo { 14 }
  end
end
