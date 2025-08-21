# syntax = docker/dockerfile:experimental

FROM node:22.14.0-bookworm-slim AS node

FROM ruby:3.4.1-slim-bookworm AS ruby

COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /opt/yarn* /opt/yarn/
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
 && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG RAILS_ENV
ARG PRIVATE_PACKAGE_GITHUB_TOKEN

ENV PRIVATE_PACKAGE_GITHUB_TOKEN=${PRIVATE_PACKAGE_GITHUB_TOKEN}
ENV LC_ALL ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LANG=ja_JP.UTF-8
ENV RUBYOPT="--yjit"
ENV TZ=Asia/Tokyo
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3
ENV BUNDLE_PATH=/app/vendor/bundle
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV BUNDLE_WITHOUT=""
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y \
    build-essential \
    libxslt-dev \
    libxml2-dev \
    default-libmysqlclient-dev \
    default-mysql-client \
    tzdata \
    shared-mime-info \
    less \
    git \
    locales \
    && \
  apt-get clean && \
  rm -rf /var/cache/apt/archives/* && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

ENV PATH /root/.yarn/bin:/app/vendor/bundle/bin:$PATH

RUN mkdir -p /app

RUN gem install -N bundler

WORKDIR /app
COPY Gemfile Gemfile.lock /app/

RUN bundle config set app_config .bundle
RUN bundle config set path .cache/bundle
RUN --mount=type=cache,target=/app/.cache/bundle bundle install && \
  bundle clean && \
  mkdir -p vendor && \
  cp -ar .cache/bundle vendor/
RUN bundle config set path vendor/bundle

# RUN --mount=type=cache,target=/app/.cache/node_modules yarn install --frozen-lockfile --module-folders .cache/node_modules && \
#   cp -ar .cache/node_modules node_modules

# COPY frontend/.npmrc frontend/package.json frontend/yarn.lock /app/frontend/
# WORKDIR /app/frontend

# RUN --mount=type=cache,target=/app/.cache/frontend_node_modules yarn install --frozen-lockfile --module-folders /app/.cache/frontend_node_modules && \
#   cp -ar /app/.cache/frontend_node_modules node_modules

WORKDIR /app
COPY . /app
