class UserSerializer < ActiveModel::Serializer
  attributes %i[
    id
    name
    avatar_url
  ]

  def avatar_url
    return nil unless object.avatar.attached?

    Rails.application.routes.url_helpers.url_for(object.avatar)
  end
end
