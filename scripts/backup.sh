#!/usr/bin/env bash
# Hot backup of the Vaultwarden SQLite DB + attachments.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
DATA_DIR="$ROOT/data"
BACKUP_DIR="$ROOT/backups"
RETENTION_DAYS="${RETENTION_DAYS:-30}"

mkdir -p "$BACKUP_DIR"
TS="$(date +%Y%m%d-%H%M%S)"
OUT="$BACKUP_DIR/vaultwarden-$TS.tar.gz"

# Online SQLite snapshot to avoid corrupting the live DB.
docker compose -f "$ROOT/docker-compose.yml" exec -T vaultwarden \
	sqlite3 /data/db.sqlite3 ".backup '/data/db.sqlite3.bak'"

tar -czf "$OUT" -C "$DATA_DIR" .
rm -f "$DATA_DIR/db.sqlite3.bak"

find "$BACKUP_DIR" -name 'vaultwarden-*.tar.gz' -mtime "+$RETENTION_DAYS" -delete

echo "Backup created: $OUT"
