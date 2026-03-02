#!/bin/bash
# Complete setup script for Month 4 code labs

echo "🚀 Setting up Docker Code Labs and Scripts..."

# Create directory structure
mkdir -p code-labs/{container-security,dockerize-app}
mkdir -p code-labs/container-security/{lab1-vulnerability-scanning,lab2-non-root-users,lab3-secrets-management,lab4-read-only-filesystems,lab5-security-benchmarks}
mkdir -p code-labs/dockerize-app/{lab1-nodejs-express,lab2-python-flask,lab3-react-nginx,lab4-fullstack-mern,lab5-microservices}
mkdir -p scripts

# Make all scripts executable
find scripts -name "*.sh" -exec chmod +x {} \;
find code-labs -name "*.sh" -exec chmod +x {} \;

echo "✅ Structure created!"
echo ""
echo "📁 Your complete Month 4 structure:"
tree -L 4 04-containerization/

echo ""
echo "🎯 Next steps:"
echo "1. cd into any lab directory to start practicing"
echo "2. Run scripts with ./scripts/script-name.sh"
echo "3. Check README.md in each lab for instructions"