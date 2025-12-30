#!/usr/bin/env bash
set -e

# This script runs as postgres during initdb
# Append logging settings to postgresql.conf

PGDATA="${PGDATA:-/var/lib/postgresql/data}"
CONF="${PGDATA}/postgresql.conf"

# Ensure config file exists
if [ ! -f "$CONF" ]; then
  echo "postgresql.conf not found at $CONF; skipping logging config" >&2
  exit 0
fi

cat >> "$CONF" <<'EOF'

# --- Custom logging configuration ---

# Enable PostgreSQL's own log collector
logging_collector = on

# Send logs to stderr, then captured to files by logging_collector
log_destination = 'stderr'

# Log directory (separate from data), inside container
log_directory = '/var/log/postgresql'

# Daily rotation, file name by weekday, truncate on rotation:
# This keeps 7 files (Mon..Sun) and overwrites each weekly, effectively
# keeping 7 days of logs and discarding older ones.
log_filename = 'postgresql-%a.log'
log_truncate_on_rotation = on          # overwrite existing file on rotation
log_rotation_age = 1d                  # rotate every 1 day
log_rotation_size = 0                  # no size-based rotation
EOF