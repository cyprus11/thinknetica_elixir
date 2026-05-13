ARG ELIXIR_VERSION=1.19.5
ARG ERLANG_VERSION=28.4.1

FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${ERLANG_VERSION}-debian-bullseye-20260505-slim AS release

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        inotify-tools git build-essential nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

COPY mix.exs mix.lock ./
COPY config config

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only ${MIX_ENV}

COPY lib lib
COPY rel rel
COPY assets assets

RUN mix compile && \
    mix assets.deploy && \
    mix release --path out

FROM hexpm/erlang:${ERLANG_VERSION}-debian-bullseye-20260505-slim AS default

WORKDIR /opt

COPY --from=release /app/out/ ./
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 4000 4369 4370
