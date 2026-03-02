#!/bin/bash
# Comprehensive security scanning script

echo "🛡️  Docker Security Scan"
echo "========================"

# Check if image name provided
if [ -z "$1" ]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

IMAGE=$1

# Function to print section headers
print_section() {
    echo -e "\n📌 $1"
    echo "------------------------"
}

# 1. Check Trivy installation
print_section "Checking Security Tools"
if ! command -v trivy &> /dev/null; then
    echo "⚠️  Trivy not installed. Installing..."
    sudo apt-get install wget apt-transport-https gnupg lsb-release
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
    echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install trivy
fi

# 2. Scan with Trivy
print_section "Vulnerability Scan (Trivy)"
trivy image --severity HIGH,CRITICAL --ignore-unfixed --no-progress $IMAGE

# 3. Check Docker Bench Security
print_section "Docker Bench Security"
if [ ! -f docker-bench-security.sh ]; then
    echo "Downloading Docker Bench Security..."
    curl -L https://raw.githubusercontent.com/docker/docker-bench-security/master/docker-bench-security.sh -o docker-bench-security.sh
    chmod +x docker-bench-security.sh
fi
./docker-bench-security.sh -c container_images

# 4. Image inspection
print_section "Image Inspection"
echo "User in image:"
docker run --rm $IMAGE whoami 2>/dev/null || echo "❌ Cannot determine user"

echo -e "\nExposed ports:"
docker inspect $IMAGE | jq '.[0].Config.ExposedPorts'

echo -e "\nEnvironment variables (checking for secrets):"
docker inspect $IMAGE | jq '.[0].Config.Env' | grep -i "PASS\|SECRET\|KEY" || echo "✅ No obvious secrets in env"

# 5. Check image size
print_section "Image Size"
docker images $IMAGE --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# 6. Generate report
print_section "Generating Report"
REPORT_FILE="security-scan-$(date +%Y%m%d-%H%M%S).txt"
{
    echo "Security Scan Report for $IMAGE"
    echo "Generated: $(date)"
    echo "================================="
    echo ""
    echo "Image: $IMAGE"
    echo "Size: $(docker images $IMAGE --format '{{.Size}}')"
    echo "Created: $(docker inspect $IMAGE | jq -r '.[0].Created')"
    echo ""
    echo "Vulnerabilities:"
    trivy image --severity HIGH,CRITICAL --format json $IMAGE | jq '.Results[] | {Target: .Target, Vulnerabilities: [.Vulnerabilities[]? | {Severity: .Severity, PkgName: .PkgName, InstalledVersion: .InstalledVersion, FixedVersion: .FixedVersion}]}'
} > $REPORT_FILE

echo -e "\n✅ Report saved to: $REPORT_FILE"