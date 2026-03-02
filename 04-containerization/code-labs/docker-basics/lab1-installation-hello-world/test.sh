#!/bin/bash
echo "🔍 Testing Docker Installation..."

if ! command -v docker &> /dev/null; then
echo "❌ Docker is not installed!"
exit 1
fi

echo "✅ Docker is installed"
echo "Version: $(docker --version)"

echo -e "\n🚀 Running hello-world container..."
docker run hello-world

echo -e "\n📊 Images on system:"
docker images | head -5

echo -e "\n✅ Lab 1 setup complete!"

