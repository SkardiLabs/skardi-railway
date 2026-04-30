#!/bin/sh
# Railway entrypoint for the Skardi template.
#
# - Ensures the SQLite database exists on the persistent volume (/data).
#   First boot copies the baked-in seed; subsequent boots keep the user's data.
# - When auth is enabled, defaults AUTH_DB_PATH onto the same volume so
#   accounts survive redeploys.
# - Starts skardi-server on the port Railway provides via $PORT.
set -eu

DATA_DIR="${DATA_DIR:-/data}"
DB_PATH="${DATA_DIR}/backend.db"
PORT="${PORT:-8080}"

mkdir -p "$DATA_DIR"

if [ ! -f "$DB_PATH" ]; then
    echo "Seeding $DB_PATH from /app/seed/backend.db"
    cp /app/seed/backend.db "$DB_PATH"
fi

# Auth is opt-in via AUTH_MODE. When it's set, make sure the auth DB lives on
# the persistent volume — the upstream default ("skardi_auth.db") is relative
# to CWD and would be lost on every redeploy.
if [ -n "${AUTH_MODE:-}" ] && [ -z "${AUTH_DB_PATH:-}" ]; then
    AUTH_DB_PATH="${DATA_DIR}/auth.db"
    export AUTH_DB_PATH
    echo "AUTH_MODE is set; defaulting AUTH_DB_PATH=${AUTH_DB_PATH}"
fi

exec skardi-server \
    --ctx /app/ctx.yaml \
    --pipeline /app/pipelines \
    --port "$PORT"
