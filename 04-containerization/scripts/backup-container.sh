#!/bin/bash
# Backup Docker containers and volumes

BACKUP_DIR="./docker-backups/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

echo "💾 Backing up Docker data to $BACKUP_DIR"

# Backup container lists
echo "📋 Saving container lists..."
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" > $BACKUP_DIR/containers.txt
docker ps -a --format "{{.Names}}" > $BACKUP_DIR/running-containers.txt

# Backup images list
echo "🖼️  Saving images list..."
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}" > $BACKUP_DIR/images.txt

# Backup volumes
echo "💽 Backing up volume data..."
for volume in $(docker volume ls -q); do
    echo "  Backing up volume: $volume"
    docker run --rm -v $volume:/volume -v $BACKUP_DIR:/backup alpine \
        tar czf /backup/volume-$volume.tar.gz -C /volume .
done

# Export container configurations
echo "⚙️  Exporting container configurations..."
for container in $(docker ps -a -q); do
    name=$(docker inspect $container --format '{{.Name}}' | cut -c2-)
    docker inspect $container > $BACKUP_DIR/config-$name.json
done

# Create backup archive
tar czf $BACKUP_DIR.tar.gz -C $(dirname $BACKUP_DIR) $(basename $BACKUP_DIR)
rm -rf $BACKUP_DIR

echo "✅ Backup complete: $BACKUP_DIR.tar.gz"