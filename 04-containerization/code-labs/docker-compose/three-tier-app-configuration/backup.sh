#!/bin/bash
# Backup script for Nikky's Portfolio Project

BACKUP_NAME="db_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

echo "🚀 Starting backup for MongoDB..."

docker run --rm \
  --volumes-from $(docker compose ps -q database) \
  -v $(pwd):/backup \
  ubuntu tar cvzf /backup/$BACKUP_NAME /data/db

echo "✅ Backup complete! File saved as: $BACKUP_NAME"