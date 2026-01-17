# ---------- build stage ----------
FROM ruby:3.4-slim AS build

ENV RAILS_ENV=production 
ENV BUNDLE_WITHOUT="development test"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libyaml-dev \
    libsqlite3-dev \
    libpq-dev \
    pkg-config \
    git \
  && rm -rf /var/lib/apt/lists/*


WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3

COPY . .

# ---------- runtime stage ----------
FROM ruby:3.4-slim

ENV RAILS_ENV=production
ENV BUNDLE_WITHOUT="development test"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libsqlite3-0 \
    libssl3 \
    libstdc++6 \
    tzdata \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 10001 appuser

WORKDIR /app

COPY --from=build /app /app

COPY --from=build /usr/local/bundle /usr/local/bundle

RUN chown -R appuser:appuser \
    /app \
    /usr/local/bundle \
    /usr/local/lib/ruby/gems

USER appuser

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]

