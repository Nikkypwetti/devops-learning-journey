🚢 Docker Compose - Complete Lab Series
📚 Lab Overview

| Lab | Topic | Key Concepts |
|-----|-------|--------------|
| 1 | First Compose File | up, down, ps, logs, basic syntax |
| 2 | Multi-Service App | Flask+Redis, WordPress, dependencies |
| 3 | Networking | Service discovery, custom networks, isolation |
| 4 | Volumes | Named volumes, bind mounts, sharing data |
| 5 | Environment Config | .env, interpolation, defaults |
| 6 | Profiles | Selective service activation |
| 7 | Compose Watch | Hot reload, development workflow |
| 8 | Multiple Files | Base + overrides, include, extends |
🚀 Quick Start
bash

# Navigate to any lab
cd lab1-first-compose-file

# Read the instructions
cat README.md

# Run the practice script
./test.sh

🎯 Learning Path

Lab 1-2: Get comfortable with basic Compose syntax 

Lab 3-4: Understand networking and data persistence

Lab 5-6: Master configuration and environment management

Lab 7-8: Learn advanced development workflows

📊 Progress Tracker

    Lab 1: First Compose File

    Lab 2: Multi-Service Application

    Lab 3: Networking in Compose

    Lab 4: Volumes in Compose

    Lab 5: Environment Configuration

    Lab 6: Compose Profiles

    Lab 7: Compose Watch

    Lab 8: Multiple Compose Files

🎉 Ready to Begin!

Each lab contains:

    📖 README with concepts and exercises

    🔧 Practice scripts to test understanding

    ✅ Success criteria to verify learning

Happy orchestrating! 🚢


---

## 🚀 **Final Setup Script**

Create a master setup script in `code-labs/` that sets up everything:

```bash
#!/bin/bash
# ============================================
# Master Setup Script for All Code Labs
# ============================================

echo "🚀 Setting up ALL Docker Code Labs"
echo "==================================="
echo ""

# Make all scripts executable
find . -name "*.sh" -exec chmod +x {} \;

# Run individual setup scripts
echo "1️⃣ Setting up Docker Basics..."
cd docker-basics
./setup-docker-basics.sh
cd ..

echo -e "\n2️⃣ Setting up Docker Compose..."
cd docker-compose
./setup-docker-compose.sh
cd ..

echo -e "\n3️⃣ Setting up Container Security..."
cd container-security
./setup-labs.sh
cd ..

echo -e "\n✅ All labs created successfully!"
echo ""
echo "📊 Summary:"
echo "   - Docker Basics: 9 labs"
echo "   - Docker Compose: 8 labs"
echo "   - Container Security: 5 labs"
echo "   Total: 22 hands-on labs!"
echo ""
echo "🎯 Next steps:"
echo "   1. cd docker-basics/lab1-installation-hello-world"
echo "   2. Read the README.md"
echo "   3. Run ./test.sh"
echo ""
echo "Happy learning! 🐳"