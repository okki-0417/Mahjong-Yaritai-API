# frozen_string_literal: true

module Types
  class WhatToDiscardProblemType < Types::BaseObject
    field :id, ID, null: false
    field :round, String, null: true
    field :turn, Integer, null: true
    field :wind, String, null: true
    field :points, String, null: true
    field :description, String, null: true
    field :user, Types::UserType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
