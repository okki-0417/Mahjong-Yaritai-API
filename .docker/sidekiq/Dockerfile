FROM ruby:3.3-slim

WORKDIR /app

# 必要なパッケージをインストール
RUN apt-get update && apt-get install --no-install-recommends -y \
    libmariadb-dev \
    libpq-dev \
    nodejs \
    g++ \
    make && \
    rm -rf /var/lib/apt/lists/*

# RailsアプリケーションのGemfileをコピーして依存関係をインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3

# アプリケーションコードをコピー
COPY . .

# Sidekiqを実行するコマンドを設定
CMD ["bundle", "exec", "sidekiq"]
