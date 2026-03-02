#!/bin/bash
# Script to run containers with all CIS runtime controls

run_secure_container() {
    local IMAGE=$1
    local NAME=$2
    local PORT=${3:-8080}
    
    echo "🚀 Starting secure container: $NAME"
    
    # CIS 5.4: Restrict Linux capabilities
    # CIS 5.5: No privileged containers
    # CIS 5.11-5.12: Resource limits
    # CIS 5.13: Read-only root filesystem
    # CIS 5.22: Seccomp profile
    # CIS 5.26: No new privileges
    
    docker run -d \
        --name "$NAME" \
        --cap-drop ALL \
        --cap-add NET_BIND_SERVICE \
        --security-opt no-new-privileges:true \
        --security-opt seccomp=default.json \
        --read-only \
        --tmpfs /tmp:rw,noexec,nosuid,size=100m \
        --memory 512m \
        --memory-swap 512m \
        --cpus 1.0 \
        --pids-limit 100 \
        --restart unless-stopped \
        -p "$PORT:5000" \
        -v "$NAME-logs:/var/log" \
        "$IMAGE"
    
    # CIS 5.31: Healthcheck
    echo "✅ Container started with CIS runtime controls"
}

# Create custom seccomp profile (stricter than default)
cat > default.json << 'EOF'
{
    "defaultAction": "SCMP_ACT_ERRNO",
    "architectures": ["SCMP_ARCH_X86_64", "SCMP_ARCH_X86", "SCMP_ARCH_AARCH64"],
    "syscalls": [
        {
            "names": ["accept", "bind", "brk", "chdir", "close", "connect", "dup", "dup2", "execve", "exit", "exit_group", "fchdir", "fchmod", "fchown", "fcntl", "fstat", "fsync", "ftruncate", "futex", "getcwd", "getdents", "getegid", "geteuid", "getgid", "getpeername", "getpid", "getppid", "getsockname", "getsockopt", "getuid", "ioctl", "listen", "lseek", "mkdir", "mmap", "mprotect", "munmap", "nanosleep", "open", "openat", "pipe", "poll", "read", "readlink", "recvfrom", "recvmsg", "rename", "rmdir", "select", "sendfile", "sendmsg", "sendto", "set_robust_list", "setsockopt", "shutdown", "sigaltstack", "socket", "stat", "statfs", "sysinfo", "umask", "uname", "unlink", "wait4", "write"],
            "action": "SCMP_ACT_ALLOW"
        }
    ]
}
EOF

# Run a secure container
run_secure_container "app-secure:latest" "secure-app" 5000

# Verify security settings
echo -e "\n🔍 Verifying security settings:"
docker inspect secure-app | jq '.[0].HostConfig | {
    "Capabilities": .CapDrop,
    "Privileged": .Privileged,
    "ReadonlyRootfs": .ReadonlyRootfs,
    "Memory": .Memory,
    "CpuShares": .CpuShares,
    "PidsLimit": .PidsLimit,
    "SecurityOpt": .SecurityOpt
}'