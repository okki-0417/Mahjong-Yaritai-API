# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim AS base

# 環境変数の設定
ENV BUNDLE_PATH=/usr/local/bundle

# 作業ディレクトリを設定
WORKDIR /rails

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips && \
    apt-get install --no-install-recommends -y libmariadb-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# ビルド用ステージ
FROM base AS build

# ビルドに必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git default-libmysqlclient-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Gemfileを先にコピーしてキャッシュを活用
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3 --path ${BUNDLE_PATH} && \
    rm -rf ~/.bundle/ ${BUNDLE_PATH}/ruby/*/cache ${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git

# アプリケーションコードをすべてコピー
COPY . .

# 必要なファイルを再生成（特に bin ファイル）
RUN bundle exec rails app:update:bin

# アセットプリコンパイル
# RUN SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=development ./bin/rails assets:precompile

# 最終ステージ
FROM base AS app

# 必要なデータをコピー
COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /rails /rails

# 非ルートユーザーを作成
RUN groupadd --system --gid 1000 rails && \
useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
mkdir -p /rails/tmp/sockets && \
mkdir -p /rails/tmp/pids && \
chown -R rails:rails /rails/tmp

# logディレクトリの権限を再設定
RUN mkdir -p /rails/log && \
    touch /rails/log/development.log && \
    chown -R rails:rails /rails/log && \
    chmod -R u+rwX,g+rwX,o-rwx /rails/log

USER 1000:1000

# デフォルトのポートを公開
EXPOSE 3001

# サーバーを起動
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001", "-e", "development"]
