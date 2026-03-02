#!/bin/bash
# CI/CD integration script for CIS compliance

set -e

echo "🔒 CIS Compliance Check"
echo "======================="

# Run Docker Bench
echo "📊 Running Docker Bench Security..."
docker run --rm \
  --net host \
  --pid host \
  --userns host \
  --cap-add audit_control \
  -v /etc:/etc:ro \
  -v /var/lib:/var/lib:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  docker/docker-bench-security > bench-results.txt

# Check for critical failures
CRITICAL_FAILS=$(grep -c "\[FAIL\] [45]\.[0-9]" bench-results.txt || true)

if [ "$CRITICAL_FAILS" -gt 0 ]; then
    echo "❌ Found $CRITICAL_FAILS critical CIS failures!"
    grep "\[FAIL\] [45]\.[0-9]" bench-results.txt
    exit 1
fi

# Check image with docker scan
echo "🔍 Scanning image for vulnerabilities..."
docker scan --severity=high,critical $1 || true  # Don't fail build on scan results

# Run custom security tests
echo "🧪 Running custom security tests..."

# Test 1: Check for root user
if docker run --rm $1 whoami | grep -q root; then
    echo "❌ Image runs as root (CIS 4.4)"
    exit 1
fi

# Test 2: Check for unnecessary packages
if docker run --rm $1 which curl >/dev/null 2>&1; then
    echo "⚠️  curl found in image (consider removing)"
fi

echo "✅ All CIS checks passed!"