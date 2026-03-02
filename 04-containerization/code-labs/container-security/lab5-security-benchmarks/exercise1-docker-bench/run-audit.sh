#!/bin/bash
# Docker Bench Security Audit Script

echo "🔐 Docker Bench Security Audit"
echo "==============================="
echo "Date: $(date)"
echo ""

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running!"
    exit 1
fi

# Run Docker Bench Security
echo "📊 Running CIS Docker Benchmark audit..."
echo ""

# Option 1: Run the official container
docker run --rm \
  --net host \
  --pid host \
  --userns host \
  --cap-add audit_control \
  -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
  -v /etc:/etc:ro \
  -v /usr/lib/systemd:/usr/lib/systemd:ro \
  -v /var/lib:/var/lib:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  docker/docker-bench-security > audit-results.txt

# Option 2: Clone and run locally (more customizable)
if [ ! -d docker-bench-security ]; then
    git clone https://github.com/docker/docker-bench-security.git
fi

cd docker-bench-security
sudo sh docker-bench-security.sh > ../audit-detailed.txt
cd ..

echo "✅ Audit complete! Results saved to:"
echo "   - audit-results.txt (container run)"
echo "   - audit-detailed.txt (local run)"

# Parse results
echo ""
echo "📈 Quick Summary:"
grep -E "WARN|FAIL" audit-results.txt | head -10
echo "... (see full results in files)"