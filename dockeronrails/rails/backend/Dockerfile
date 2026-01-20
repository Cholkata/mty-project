# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.4.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# --------------------
# Build stage
# --------------------
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libvips \
      pkg-config \
      nodejs \
      npm && \
    npm install -g yarn

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle \
           "${BUNDLE_PATH}"/ruby/*/cache \
           "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

COPY . .

RUN chmod 1777 /tmp
RUN bundle exec bootsnap precompile app/ lib/


# --------------------
# Runtime stage
# --------------------
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libsqlite3-0 \
      libvips && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# ✅ Create required Rails dirs explicitly
RUN mkdir -p /rails/tmp /rails/log /rails/storage /rails/db && \
    chmod 1777 /tmp && \
    useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails

# ✅ Correct container path
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]

