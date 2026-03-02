#!/bin/bash
echo "📦 Image Management Lab"
echo "======================="

echo -e "\n1️⃣ Pulling different nginx variants..."
docker pull nginx:latest >/dev/null 2>&1
docker pull nginx:alpine >/dev/null 2>&1
docker pull nginx:alpine-slim >/dev/null 2>&1

echo -e "\n2️⃣ Size comparison:"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep nginx

echo -e "\n3️⃣ Alpine image layers:"
docker history nginx:alpine | head -10

echo -e "\n✅ Lab ready!"