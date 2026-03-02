#!/bin/bash
# Comprehensive Docker cleanup script

set -e

echo "🧹 Starting Docker cleanup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Current disk usage:${NC}"
docker system df

echo -e "\n${YELLOW}1. Removing stopped containers...${NC}"
docker container prune -f

echo -e "\n${YELLOW}2. Removing unused images...${NC}"
docker image prune -a -f

echo -e "\n${YELLOW}3. Removing unused volumes...${NC}"
docker volume prune -f

echo -e "\n${YELLOW}4. Removing unused networks...${NC}"
docker network prune -f

echo -e "\n${YELLOW}5. Full system cleanup...${NC}"
docker system prune -a -f --volumes

echo -e "\n${GREEN}✅ Cleanup complete!${NC}"
echo -e "${YELLOW}New disk usage:${NC}"
docker system df

# Show largest images
echo -e "\n${YELLOW}Largest images remaining:${NC}"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | sort -k3 -h -r | head -10