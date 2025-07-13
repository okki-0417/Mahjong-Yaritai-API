# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes %i[
    id
    name
    avatar_url
    created_at
    updated_at
  ]

  def avatar_url
    return nil unless object.avatar.attached?

    object.avatar.url
  end
end
