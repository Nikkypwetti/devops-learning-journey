#!/bin/bash
# ============================================
# Complete Setup Script for All Security Labs
# Container Security - Labs 1 through 5
# ============================================

set -e  # Exit on error

echo "🔧 Setting up ALL Container Security Labs (1-5)"
echo "================================================"
echo ""

# Create main directory if it doesn't exist
mkdir -p container-security
cd container-security

# ============================================
# LAB 1: Vulnerability Scanning
# ============================================
echo "📁 Creating Lab 1: Vulnerability Scanning..."
mkdir -p lab1-vulnerability-scanning
cd lab1-vulnerability-scanning

# Create README
cat > README.md << 'EOF'
# Lab 1: Vulnerability Scanning

## 🎯 Objective
Learn to scan Docker images for vulnerabilities using Trivy and Docker Scout.

## 📋 Exercises
1. **Basic scanning** - Scan common images
2. **Vulnerable vs fixed** - Compare images
3. **CI/CD integration** - Automate scanning

## 🚀 Quick Start
```bash
# Make scripts executable
chmod +x *.sh

# Run basic scan
./scan-image.sh

# Compare vulnerable vs fixed
./compare-images.sh

Build both images

docker build -f Dockerfile.vulnerable -t app-vulnerable .
docker build -f Dockerfile.fixed -t app-fixed .

Show sizes

echo -e "\n📊 Image Sizes:"
docker images app-vulnerable app-fixed --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Run scans
docker scan --severity=high,critical app-vulnerable
docker scan --severity=high,critical app-fixed

chmod +x *.sh
cd ..

============================================
LAB 2: Non-Root Users
============================================

echo "📁 Creating Lab 2: Non-Root Users..."
mkdir -p lab2-non-root-users
cd lab2-non-root-users
Create README

cat > README.md << 'EOF'
Lab 2: Non-Root Users in Containers
🎯 Objective

Learn why running containers as non-root is critical for security.
📋 Exercises

    Compare root vs non-root - See the difference

    Create secure Dockerfile - Add user properly

    Test permissions - Verify user restrictions

🚀 Quick Start
```bash
# Make scripts executable
chmod +x *.sh
# Run user test
./test-user.sh
cd ..

============================================
LAB 3: Secrets Management
============================================

echo "📁 Creating Lab 3: Secrets Management..."
mkdir -p lab3-secrets-management
cd lab3-secrets-management
Create README

cat > README.md << 'EOF'
Lab 3: Secrets Management
🎯 Objective

Learn secure patterns for handling sensitive data in containers.
📋 Exercises

    Bad practices - What NOT to do

    Build args - Build-time secrets

    Docker secrets - Runtime secrets

    Environment files - External configuration

🚀 Quick Start
bash

# Make scripts executable
chmod +x *.sh

# Run the secrets management demo
./manage-secrets.sh


## 📚 **Key References**

These labs are based on:

1. **CIS Docker Benchmark**: Section 4 (Container Images) and Section 5 (Runtime) requirements [citation:2]
2. **Read-Only Filesystem Best Practices**: Immutability as a security control [citation:4][citation:7]
3. **Practical Security Patterns**: From comprehensive Docker security guides [citation:3]

Each lab builds on the previous ones and gives you hands-on experience with real-world security configurations that
you can immediately apply to your Day 21 Secure Setup project!

#!/bin/bash
# Complete setup for Labs 4 & 5

echo "🔧 Setting up Container Security Labs 4 & 5"

# Create directory structure
mkdir -p lab4-read-only-filesystem/{exercise1-basic,exercise2-nginx,exercise3-flask}
mkdir -p lab5-security-benchmarks/{exercise1-docker-bench,exercise2-cis-controls,exercise3-runtime,exercise4-automation}

# Make all scripts executable
find . -name "*.sh" -exec chmod +x {} \;

# Create README for the security section
cat > README.md << 'EOF'
# Container Security Labs 4 & 5

## Lab 4: Read-Only Filesystems
- **Exercise 1**: Basic read-only containers
- **Exercise 2**: Nginx with read-only root
- **Exercise 3**: Python Flask immutable app

## Lab 5: Security Benchmarks & CIS Compliance
- **Exercise 1**: Docker Bench Security audits
- **Exercise 2**: Implementing CIS controls
- **Exercise 3**: Runtime security hardening  
- **Exercise 4**: CI/CD integration & reporting

## Prerequisites
- Docker Engine 20.10+
- Docker Compose (optional)
- jq, curl, trivy (recommended)

## Quick Start
```bash
# For Lab 4
cd lab4-read-only-filesystem/exercise1-basic
./run-tests.sh

# For Lab 5
cd lab5-security-benchmarks/exercise1-docker-bench
./run-audit.sh

EOF

echo "✅ Setup complete!"
echo ""
echo "📁 Your labs are ready at:"
echo " lab4-read-only-filesystem/"
echo " lab5-security-benchmarks/"
text


## 📚 **Key References**

These labs are based on:

1. **CIS Docker Benchmark**: Section 4 (Container Images) and Section 5 (Runtime) requirements [citation:2]
2. **Read-Only Filesystem Best Practices**: Immutability as a security control [citation:4][citation:7]
3. **Practical Security Patterns**: From comprehensive Docker security guides [citation:3]

Each lab builds on the previous ones and gives you hands-on experience with real-world security configurations that
you can immediately apply to your Day 21 Secure Setup project!