# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :profile_text, String, null: true
    field :avatar_url, String, null: true
    field :is_following, Boolean, null: false
    field :following_count, Integer, null: false
    field :followers_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def avatar_url
      return nil unless object.avatar.attached?

      begin
        object.avatar.url
      rescue
        Rails.application.routes.url_helpers.url_for(object.avatar)
      end
    end

    def is_following
      return false unless context[:current_user]

      context[:current_user].following?(object)
    end

    def following_count
      object.following.count
    end

    def followers_count
      object.followers.count
    end
  end
end
