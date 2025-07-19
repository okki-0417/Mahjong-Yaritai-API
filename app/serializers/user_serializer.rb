# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes %i[
    id
    name
    profile_text
    avatar_url
    created_at
    updated_at
  ]

  def avatar_url
    return nil unless object.avatar.attached?

    begin
      object.avatar.url
    rescue
      Rails.application.routes.url_helpers.url_for(object.avatar)
    end
  end
end
