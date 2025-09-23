# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## プロジェクト概要

「麻雀ヤリタイ」の Rails 7.2.1 API専用アプリケーションです。ユーザーが麻雀の手牌を分析し、どの牌を切るべきかを投票する「何切る問題」に特化したプラットフォームです。

### コアアーキテクチャ

- **フレームワーク**: Rails 7.2.1 (API専用モード)
- **データベース**: PostgreSQL + Redis (セッション・バックグラウンドジョブ用)
- **認証**: カスタムメール認証システム（パスワードなし）
- **バックグラウンドジョブ**: Sidekiq (Redis使用)
- **ファイルストレージ**: ActiveStorage (開発:ローカル、本番:S3)
- **API**: REST エンドポイント + OpenAPI 3.0.1 ドキュメント + GraphQL
- **シリアライゼーション**: ActiveModel::Serializer

## 主要ドメインモデル

### 認証システム
- **AuthRequest**: メール認証トークン管理（6桁コード、15分有効）
- **User**: ユーザーモデル（アバター付き、メール認証のみ）
- パスワード認証なし - メールで送信される一時トークンを使用

### 麻雀ドメイン
- **Tile**: 34種類の麻雀牌（萬子、筒子、索子、字牌）
- **WhatToDiscardProblem**: 13枚の手牌 + 1枚のツモ牌、ユーザーが何を切るか投票
- **WhatToDiscardProblem::Vote**: ユーザーの投票
- **Comments & Likes**: 問題に対するソーシャル機能

### 主要な関連
```ruby
User has_many :created_what_to_discard_problems
WhatToDiscardProblem belongs_to 14牌 (hand1_id..hand13_id, tsumo_id, dora_id)
WhatToDiscardProblem has_many :votes, :comments, :likes
```

## 開発環境

### Docker セットアップ
すべてのコマンドは Docker Compose を使用：
```bash
# サービス起動
docker compose up

# Rails コマンド実行
docker compose exec app bundle exec rails [コマンド]

# データベース操作
docker compose exec app bundle exec rails db:create db:migrate db:seed

# コンソール
docker compose exec app bundle exec rails console

# テスト
docker compose exec app bundle exec rspec
docker compose exec app bundle exec rspec spec/specific_file_spec.rb
```

### 主要サービス
- **app**: Rails アプリケーション (ポート 3001)
- **sidekiq**: バックグラウンドジョブワーカー
- **db**: PostgreSQL データベース
- **redis**: セッションストア・ジョブキュー

## テストとドキュメント

### RSpec + Rswag テスト
Rswag を使用して RSpec テストから OpenAPI (Swagger) ドキュメントを自動生成：

```bash
# 全テスト実行
docker compose exec app bundle exec rspec

# 特定テスト実行
docker compose exec app bundle exec rspec spec/requests/users_spec.rb

# RSpec テストから swagger.yml を自動生成
docker compose exec app bundle exec rails rswag:specs:swaggerize
```

### Rswag の特徴
- **テストとドキュメントの統合**: RSpec テストがそのまま API ドキュメントになる
- **自動生成**: `spec/requests/` のテストから `swagger/v1/swagger.yaml` を生成
- **リクエスト/レスポンスの検証**: テスト実行時に OpenAPI スキーマに対して自動検証
- **実例の記録**: テストで使用した実際のリクエスト/レスポンスをドキュメントに含める

### API ドキュメント
- Swagger UI: `/api-docs` で利用可能
- 生成元: `spec/requests/` の rswag スペック
- 出力先: `swagger/v1/swagger.yaml`
- OpenAPI 3.0.1 仕様準拠

## 主要な設定パターン

### 環境別設定
- **開発**: `:local` ストレージ、`:sidekiq` ジョブ、letter_opener_web でメール確認
- **本番**: `:amazon` ストレージ (S3)、SMTP メール、カスタムロギング
- **テスト**: `:test` ストレージ、`:test` ジョブアダプター

### カスタムミドルウェアとロギング
- `CustomLogger`: ヘルスチェックログと頻繁なセッションチェックをフィルター
- Redis による環境別セキュリティ設定でのセッション管理

### 認証フロー
1. POST `/auth/request` でメール送信 → 6桁トークン送信
2. POST `/auth/verification` でトークン検証 → ユーザーデータ返却 + セッション設定
3. Redis でセッション管理、1ヶ月後に期限切れ

## API 構造

### 名前空間付きコントローラー
- `Auth::` - 認証エンドポイント
- `Me::` - ユーザー固有アクション（プロフィール、退会）
- `WhatToDiscardProblems::` - ネストされたリソース（コメント、投票、いいね）

### 主要エンドポイント
- `GET /session` - 現在のユーザーセッション（フロントエンドから頻繁に呼び出し）
- `POST /what_to_discard_problems` - 新規問題作成
- `GET /what_to_discard_problems/:id/votes/result` - 投票結果取得
- `POST /me/withdrawal` - ユーザーアカウント削除（メール通知付き）

## バックグラウンドジョブとメール

### Sidekiq 設定
- Redis をジョブキューに使用
- ワーカー用の独立 Docker コンテナ
- ActiveJob 経由でメール配信とファイル処理を実行

### メールシステム
- 開発: letter_opener_web
- 本番: Gmail 経由の SMTP
- 自動メール: 認証トークン、退会確認

## ファイルストレージとアセット

### ActiveStorage 設定
- 開発/テスト: ローカルディスクストレージ
- 本番: AWS S3（適切な環境変数設定）
- シリアライザー経由でアバター URL 生成（エラーハンドリング付き）

## 特別なアーキテクチャメモ

### カーソルベースのページネーション
`Paginationable` concern でのカスタム実装、オフセットページネーションより高パフォーマンス

### カスタムバリデーター
- 麻雀手牌の並び順バリデーション（理牌バリデーション）
- 日本語ローカライズエラーメッセージ

### セッションセキュリティ
- 環境別の異なるセッション設定
- Redis ベースセッション（適切な Cookie 設定）
- CSRF 保護無効（API 専用）

## 環境変数

### 開発環境で必要
```
REDIS_HOST=redis
REDIS_PORT=6379
HOST_NAME=localhost:3001
USER_AGENT=your-health-check-agent
```

### 本番環境で必要
```
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=ap-northeast-1
AWS_S3_BUCKET=
FRONTEND_HOST=
MAIL_ADDRESS=
MAIL_PASSWORD=
```

## データベースコマンド

```bash
# 作成とセットアップ
docker compose exec app bundle exec rails db:create db:migrate

# 麻雀牌とテストデータのシード
docker compose exec app bundle exec rails db:seed

# データベースリセット
docker compose exec app bundle exec rails db:drop db:create db:migrate db:seed
```

## デプロイメント

- Kamal デプロイメント設定済み
- Render デプロイメント対応
- Sentry エラー監視統合
- カスタムヘルスチェックエンドポイント: `/` と `/up`

## Rswag テストパターン

### 基本構造
```ruby
RSpec.describe "リソース名", type: :request do
  path "/エンドポイント" do
    get("説明") do
      tags "タグ名"
      operationId "操作ID"
      produces "application/json"

      parameter name: :パラメータ名, in: :query, type: :string

      response(200, "成功") do
        schema type: :object, properties: { ... }
        run_test!
      end
    end
  end
end
```

### テストからSwagger生成
- テストファイル: `spec/requests/*_spec.rb`
- 生成コマンド: `docker compose exec app bundle exec rails rswag:specs:swaggerize`
- 出力: `swagger/v1/swagger.yaml`

## データベーススキーマ要点

### 主要テーブル
- `users`: メールベース認証、20文字以内の名前
- `tiles`: 34種類の麻雀牌（suit, ordinal_number_in_suit）
- `what_to_discard_problems`: 14牌（hand1-13, tsumo, dora）+ メタ情報
- `what_to_discard_problem_votes`: ユーザーの投票（ユニーク制約）
- `comments`: ポリモーフィック、自己参照（返信）
- `likes`: ポリモーフィック、ユーザーごとにユニーク
- `auth_requests`: 6桁トークン、15分有効期限

### インデックスとカウンターキャッシュ
- ユニークインデックス: email, user_id + what_to_discard_problem_id
- カウンターキャッシュ: comments_count, likes_count, votes_count, replies_count