#!/bin/bash
# Compare insecure vs secure images

echo "🔍 Comparing Insecure vs Secure Images"
echo "======================================"

# Build both images
docker build -f Dockerfile.insecure -t app-insecure:latest .
docker build -f Dockerfile.secure -t app-secure:latest .

# Check users
echo -e "\n📋 User in insecure image:"
docker run --rm app-insecure whoami

echo -e "\n📋 User in secure image:"
docker run --rm app-secure whoami

# Check image sizes
echo -e "\n📦 Image sizes:"
docker images app-insecure app-secure --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Scan for vulnerabilities (if Trivy installed)
if command -v trivy &> /dev/null; then
    echo -e "\n🛡️  Vulnerability scan (CRITICAL only):"
    echo "Insecure image:"
    trivy image --severity CRITICAL --no-progress app-insecure | grep -v "Total"
    echo ""
    echo "Secure image:"
    trivy image --severity CRITICAL --no-progress app-secure | grep -v "Total"
fi

# Check Dockerfile with hadolint
if command -v hadolint &> /dev/null; then
    echo -e "\n📝 Dockerfile linting:"
    echo "Insecure Dockerfile issues:"
    hadolint Dockerfile.insecure | head -5
    echo ""
    echo "Secure Dockerfile:"
    hadolint Dockerfile.secure
fi