class AvatarProcessingJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    # アバター処理のロジックをここに記述
    # 例: 画像のリサイズ、サムネイル生成、外部サービスへのアップロードなど
    Rails.logger.info "Processing avatar for user #{user.id}"
  end
end
