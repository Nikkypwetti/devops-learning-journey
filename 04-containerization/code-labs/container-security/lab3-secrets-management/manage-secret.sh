#!/bin/bash
# Script to manage secrets securely

echo "🔐 Docker Secrets Management"

RUN mkdir -p /run/secrets
Copy entrypoint script

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cat", "/run/secrets/app/config"]
EOF
Create entrypoint.sh

cat > entrypoint.sh << 'EOF'
#!/bin/sh
Read secrets from mounted directory

if [ -f /run/secrets/db_password ]; then
DB_PASSWORD=$(cat /run/secrets/db_password)
export DB_PASSWORD
echo "✅ Database password loaded from secret"
fi

if [ -f /run/secrets/api_key ]; then
API_KEY=$(cat /run/secrets/api_key)
export API_KEY
echo "✅ API key loaded from secret"
fi
Execute the command

exec "$@"
EOF

# Create secrets directory with restricted permissions
mkdir -p secrets
chmod 700 secrets

# Generate random passwords
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

# Create secrets if they don't exist
if [ ! -f secrets/db_password.txt ]; then
    echo "📝 Generating database password..."
    generate_password > secrets/db_password.txt
    chmod 600 secrets/db_password.txt
    echo "✅ Password saved to secrets/db_password.txt"
fi

if [ ! -f secrets/api_key.txt ]; then
    echo "📝 Generating API key..."
    generate_password > secrets/api_key.txt
    chmod 600 secrets/api_key.txt
    echo "✅ API key saved to secrets/api_key.txt"
fi

# Show instructions
echo -e "\n🚀 To use secrets in Docker Swarm:"
echo "docker secret create db_password secrets/db_password.txt"
echo "docker secret create api_key secrets/api_key.txt"

echo -e "\n🔍 To verify secrets are secure:"
echo "ls -la secrets/  # Should show 600 permissions"

Create .gitignore to prevent accidental commits

cat > .gitignore << 'EOF'
Ignore secrets

/secrets/
*.txt
!.gitignore
.env
*.env
EOF

chmod +x *.sh
cd ..