# Lab 4: Read-Only Filesystems & Immutable Containers

## 🎯 Learning Objectives

- Understand container immutability principles
- Implement read-only root filesystems
- Handle write operations with tmpfs and volumes
- Apply defense-in-depth security

## 📚 Background

Read-only root filesystems enforce **immutability**—a cornerstone of both security and reliability in modern containerized environments [citation:7]. When a container's root filesystem is read-only:

✅ Attackers can't tamper with binaries or libraries
✅ Operational consistency ensures every container matches the image exactly
✅ Stateless architecture forces proper separation of ephemeral and persistent data

## ⚙️ Setup Instructions

```bash
# Create lab directory
mkdir -p lab4-read-only-filesystem
cd lab4-read-only-filesystem