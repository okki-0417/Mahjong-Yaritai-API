module Mutations
  class CreateUser < BaseMutation
    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    argument :name, String, required: true
    argument :email, String, required: true
    argument :profile_text, String, required: false
    argument :avatar, Types::UploadType, required: false

    def resolve(name:, email:, profile_text: nil, avatar: nil)
      # 認証必須（新規ユーザー登録時はauth_request_idがセッションにある）
      auth_request_id = context[:session][:auth_request_id]
      unless auth_request_id.present?
        return { user: nil, errors: [ "認証が必要です" ] }
      end

      # メール認証が完了していることを確認
      auth_request = AuthRequest.find_by(id: auth_request_id, email: email)
      unless auth_request&.within_valid_period?
        return { user: nil, errors: [ "認証が無効です" ] }
      end

      begin
        user = User.new(name: name, email: email)
        user.profile_text = profile_text if profile_text.present?

        # アバター画像がある場合はattach
        user.avatar.attach(avatar) if avatar.present?

        if user.save
          # セッションにユーザーIDを設定してログイン
          context[:session][:user_id] = user.id
          context[:session][:remember_user_id] = user.id
          context[:session].delete(:auth_request_id)
          context[:current_user] = user

          { user: user, errors: [] }
        else
          { user: nil, errors: user.errors.full_messages }
        end
      rescue => e
        Rails.logger.error "CreateUser mutation error: #{e.message}"
        { user: nil, errors: [ "ユーザー作成に失敗しました" ] }
      end
    end
  end
end
