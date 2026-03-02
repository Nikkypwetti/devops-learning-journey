#!/bin/bash
IMAGE_NAME="secure-app:latest"

echo "🚀 1. Building the secure image..."
# Adding --pull ensures we check for updated base images
docker build -t $IMAGE_NAME .

# Check if build succeeded before continuing
if [ $? -ne 0 ]; then
    echo "❌ Build failed! Fix the Dockerfile or app files first."
    exit 1
fi

echo "----------------------------------------"
echo "🔍 2. Scanning for Vulnerabilities (Docker Scout)..."
# In Scout, we use 'cves' and specify the threshold for exit code
docker scout cves $IMAGE_NAME --exit-code --only-severity high,critical

echo "----------------------------------------"
echo "👤 3. Checking for Non-Root User..."
# Note: Using 'node' because the Node alpine image has a 'node' user by default
CURRENT_USER=$(docker run --rm $IMAGE_NAME whoami)

if [ "$CURRENT_USER" == "root" ]; then
    echo "🚨 SECURITY ALERT: Container is running as ROOT!"
    exit 1
else
    echo "✅ SUCCESS: Container running as user: $CURRENT_USER"
fi

echo "----------------------------------------"
echo "📊 4. Image Size Audit..."
docker images $IMAGE_NAME --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

echo "----------------------------------------"
echo "✅ Security scan complete for $IMAGE_NAME"