# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
<<<<<<< HEAD
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips && \
    apt-get install --no-install-recommends -y libmariadb-dev && \
    apt-get install --no-install-recommends -y build-essential git default-libmysqlclient-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
=======
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    libmariadb-dev \
    build-essential \
    git \
    default-libmysqlclient-dev \
    pkg-config \
    libyaml-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
>>>>>>> 535bbb4 (進捗)

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs=4 --retry=3 --path /usr/local/bundle && \
    rm -rf ~/.bundle/ /usr/local/bundle/ruby/*/cache /usr/local/bundle/ruby/*/bundler/gems/*/.git

EXPOSE 3001

COPY . .

<<<<<<< HEAD
# サーバーを起動
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001"]
=======
CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bin/rails server -b 0.0.0.0 -p 3001"]
>>>>>>> 535bbb4 (進捗)
