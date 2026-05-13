#!/bin/sh
set -e

echo "Starting epmd..."

export ELIXIR_ERL_OPTIONS='-kernel shell_history enabled'
export ERL_AFLAGS="-proto_dist inet_tcp -kernel inet_dist_listen_min 4370 inet_dist_listen_max 4370"

/usr/local/bin/epmd -daemon

echo "Setup database..."

bin/custom_ai eval CustomAi.Release.migrate

echo "Starting app..."

exec bin/custom_ai start
