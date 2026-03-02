
### **Exercise 1: Basic Read-Only Container**

```markdown
# Exercise 1: Basic Read-Only Container

## Step 1: Create a Test Image

**`Dockerfile.test`**
```dockerfile
FROM alpine:latest

# Create directories that need write access
RUN mkdir -p /data /var/log /tmp

# Create sample files
RUN echo "This is a configuration file" > /data/config.txt && \
    echo "Application log starter" > /var/log/app.log

WORKDIR /data
CMD ["sh", "-c", "while true; do sleep 30; done"]

Build it:
bash

docker build -f Dockerfile.test -t readonly-test .

Step 2: Run Standard Container (Writable)
bash

# Run normally (writable)
docker run -d --name writable-container readonly-test

# Test writing - this will succeed
docker exec writable-container sh -c "echo 'new data' >> /data/config.txt"
docker exec writable-container touch /data/newfile.txt

# Verify files were created
docker exec writable-container ls -la /data/

# Clean up
docker stop writable-container && docker rm writable-container

Step 3: Run with Read-Only Root Filesystem
bash

# Run with read-only root
docker run -d --name readonly-container --read-only readonly-test

# Test writing - this will FAIL with "Read-only file system"
docker exec readonly-container sh -c "echo 'new data' >> /data/config.txt"
# Expected: sh: can't create /data/config.txt: Read-only file system

# Inspect to verify read-only flag
docker inspect readonly-container | grep ReadonlyRootfs
# Expected: "ReadonlyRootfs": true

# Clean up
docker stop readonly-container && docker rm readonly-container

Step 4: Fix with Tmpfs for Writable Locations

Many applications need to write temporary files. Use --tmpfs for ephemeral storage

.
bash

# Run with read-only + tmpfs for writable locations
docker run -d \
  --name fixed-container \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=100m \
  --tmpfs /var/log:rw,noexec,nosuid,size=50m \
  readonly-test

# Now writing to /tmp should work
docker exec fixed-container touch /tmp/test.tmp
echo $?  # Should return 0 (success)

# But writing to /data still fails (not mounted as tmpfs)
docker exec fixed-container touch /data/test.tmp
# Expected: touch: /data/test.tmp: Read-only file system

# Clean up
docker stop fixed-container && docker rm fixed-container

Key Takeaways ✨

    --read-only mounts container root filesystem as immutable

    Use --tmpfs for ephemeral data that doesn't need persistence

    Tmpfs mounts can have size limits and security options (noexec, nosuid)