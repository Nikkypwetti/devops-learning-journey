#!/bin/bash
# Test script to verify Flask app works correctly with different read-only filesystem configurations
echo "🔬 Testing Flask with Different Mount Configurations"

# Build image
docker build -t flask-test .

# Test 1: No read-only (baseline)
echo -e "\n📋 Test 1: Standard (writable)"
docker run --rm --name flask-standard flask-test python -c "
import os
try:
    with open('/tmp/test.txt', 'w') as f:
        f.write('test')
    print('✅ /tmp is writable')
    os.remove('/tmp/test.txt')
except Exception as e:
    print(f'❌ /tmp error: {e}')
"

# Test 2: Read-only only (will fail)
echo -e "\n📋 Test 2: Read-only (will fail)"
docker run --rm --read-only flask-test python -c "
import os
try:
    with open('/tmp/test.txt', 'w') as f:
        f.write('test')
    print('❌ This should have failed!')
except Exception as e:
    print(f'✅ Correctly failed: {e}')
" || echo "Container exited as expected"

# Test 3: Read-only with tmpfs
echo -e "\n📋 Test 3: Read-only + tmpfs"
docker run --rm \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=50m \
  flask-test python -c "
import os
try:
    with open('/tmp/test.txt', 'w') as f:
        f.write('test')
    print('✅ /tmp is writable with tmpfs')
    os.remove('/tmp/test.txt')
    
    # Try writing to /app (should fail)
    with open('/app/test.txt', 'w') as f:
        f.write('test')
    print('❌ /app should not be writable')
except Exception as e:
    print(f'✅ /app correctly read-only: {e}'
"

# Test 4: Complete secure configuration
echo -e "\n📋 Test 4: Complete secure config"
docker run -d \
  --name flask-secure \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=50m \
  --tmpfs /var/log/flask:rw,noexec,nosuid,size=20m \
  -v flask-data:/data \
  -p 5000:5000 \
  flask-test

sleep 3
curl -s http://localhost:5000 | python -m json.tool

# Clean up
docker stop flask-secure && docker rm flask-secure