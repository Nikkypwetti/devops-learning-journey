#!/bin/bash
# Test script to verify user permissions in root vs non-root Docker images
echo "🔐 Testing user permissions..."

# Build both images
docker build -f Dockerfile.root -t app-root .
docker build -f Dockerfile.secure -t app-secure .

# Check users
echo -e "\n📋 Root image user:"
docker run --rm app-root whoami

echo -e "\n📋 Secure image user:"
docker run --rm app-secure whoami

# Test file permissions
echo -e "\n📁 Testing file write permissions..."
docker run --rm app-root touch /test-root && echo "✅ Root can write anywhere"
docker run --rm app-secure touch /test-secure 2>&1 || echo "✅ Non-root can't write to root (secure!)"

#Test user ID
echo -e "\n🆔 User IDs:"
echo "Root image UID: $(docker run --rm app-root id -u)"
echo "Secure image UID: $(docker run --rm app-secure id -u)"

#Clean up
rm -f package.json server.js
echo -e "\n✅ Test complete!"