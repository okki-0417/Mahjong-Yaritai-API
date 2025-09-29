module Mutations
  class UpdateUser < BaseMutation
    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    argument :name, String, required: false
    argument :profile_text, String, required: false
    argument :avatar, Types::UploadType, required: false

    def resolve(name: nil, profile_text: nil, avatar: nil)
      return { user: nil, errors: [ "ログインが必要です" ] } unless context[:current_user]

      user = context[:current_user]

      # 更新用のattributesを構築
      attributes = {}
      attributes[:name] = name if name.present?
      attributes[:profile_text] = profile_text if profile_text.present?

      begin
        # アバター画像がある場合は個別に処理
        if avatar.present?
          user.avatar.attach(avatar)
        end

        # その他の属性を更新
        if attributes.present? && !user.update(attributes)
          return { user: nil, errors: user.errors.full_messages }
        end

        { user: user.reload, errors: [] }
      rescue => e
        Rails.logger.error "UpdateUser mutation error: #{e.message}"
        { user: nil, errors: [ "ファイルアップロードに失敗しました" ] }
      end
    end
  end
end
