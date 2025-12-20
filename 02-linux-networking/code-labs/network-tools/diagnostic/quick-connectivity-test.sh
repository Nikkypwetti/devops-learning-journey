#!/bin/bash

# ============================================
# Quick Connectivity Test
# ============================================
# Basic network connectivity testing tool
# ============================================

echo "🔌 Quick Connectivity Test"
echo "========================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test targets
TEST_TARGETS=(
    "Localhost:127.0.0.1"
    "Gateway:(auto)"
    "Google DNS:8.8.8.8"
    "Cloudflare DNS:1.1.1.1"
    "Google:google.com"
    "GitHub:github.com"
)

# Function to test connectivity
test_ping() {
    local name=$1
    local target=$2
    
    # Handle special cases
    if [ "$target" == "(auto)" ]; then
        # Get default gateway
        target=$(ip route | grep default | awk '{print $3}')
        if [ -z "$target" ]; then
            echo -e "${RED}❌ $name: No gateway found${NC}"
            return 1
        fi
    fi
    
    echo -n "Testing $name ($target)... "
    if ping -c 2 -W 1 "$target" &> /dev/null; then
        # Get average ping time
        time=$(ping -c 2 -W 1 "$target" | grep "avg" | awk -F'/' '{print $5}' | cut -d'.' -f1)
        if [ -n "$time" ]; then
            echo -e "${GREEN}✅ OK (${time}ms)${NC}"
        else
            echo -e "${GREEN}✅ OK${NC}"
        fi
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        return 1
    fi
}

# Function to test port
test_port() {
    local name=$1
    local host=$2
    local port=$3
    
    echo -n "Testing $name ($host:$port)... "
    if nc -z -w 2 "$host" "$port" &> /dev/null; then
        echo -e "${GREEN}✅ OPEN${NC}"
        return 0
    else
        echo -e "${RED}❌ CLOSED${NC}"
        return 1
    fi
}

# Function to test DNS
test_dns() {
    local domain=$1
    
    echo -n "Testing DNS ($domain)... "
    if nslookup "$domain" &> /dev/null; then
        # Get IP
        ip=$(nslookup "$domain" | grep "Address:" | tail -1 | awk '{print $2}')
        echo -e "${GREEN}✅ OK ($ip)${NC}"
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        return 1
    fi
}

# Main tests
echo ""
echo "1. Ping Tests:"
echo "--------------"

success_count=0
total_count=0

for target in "${TEST_TARGETS[@]}"; do
    name=$(echo "$target" | cut -d':' -f1)
    addr=$(echo "$target" | cut -d':' -f2)
    
    test_ping "$name" "$addr"
    if [ $? -eq 0 ]; then
        ((success_count++))
    fi
    ((total_count++))
done

echo ""
echo "2. Common Port Tests:"
echo "---------------------"

# Test common ports
PORTS=("SSH:22" "HTTP:80" "HTTPS:443" "DNS:53")

for port_test in "${PORTS[@]}"; do
    name=$(echo "$port_test" | cut -d':' -f1)
    port=$(echo "$port_test" | cut -d':' -f2)
    
    test_port "$name" "localhost" "$port"
done

echo ""
echo "3. DNS Tests:"
echo "-------------"

test_dns "google.com"
test_dns "github.com"

echo ""
echo "4. Network Information:"
echo "----------------------"

# Get IP address
echo -n "Your IP address: "
ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v "127.0.0.1" | head -1

# Get gateway
echo -n "Default gateway: "
ip route | grep default | awk '{print $3}'

# Get DNS servers
echo -n "DNS servers: "
cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | tr '\n' ' '
echo ""

echo ""
echo "5. Internet Speed Test (basic):"
echo "------------------------------"

echo -n "Testing download speed... "
# Simple speed test by downloading a small file
start_time=$(date +%s)
curl -s -o /dev/null https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py 2>/dev/null
end_time=$(date +%s)
duration=$((end_time - start_time))

if [ $duration -lt 5 ]; then
    echo -e "${GREEN}✅ Fast (<5s)${NC}"
elif [ $duration -lt 10 ]; then
    echo -e "${YELLOW}⚠️  Medium (5-10s)${NC}"
else
    echo -e "${RED}❌ Slow (>10s)${NC}"
fi

echo ""
echo "📊 Summary:"
echo "-----------"
echo "Ping tests: $success_count/$total_count successful"
echo ""

if [ $success_count -eq $total_count ]; then
    echo -e "${GREEN}🎉 All tests passed! Your network looks good.${NC}"
elif [ $success_count -eq 0 ]; then
    echo -e "${RED}🚨 No tests passed. Check your network connection.${NC}"
    echo ""
    echo "💡 Troubleshooting steps:"
    echo "   1. Check cable/WiFi connection"
    echo "   2. Restart router/modem"
    echo "   3. Check firewall settings"
    echo "   4. Contact ISP if problem continues"
else
    echo -e "${YELLOW}⚠️  Some tests failed. Partial connectivity.${NC}"
    echo ""
    echo "💡 Common issues:"
    echo "   - DNS not working: Try using 8.8.8.8 as DNS"
    echo "   - Can't reach internet: Check gateway and firewall"
    echo "   - Slow speeds: Check for network congestion"
fi

echo ""
echo "🕐 Test completed at: $(date)"
echo ""
echo "💡 Quick fixes to try:"
echo "   sudo systemctl restart networking"
echo "   sudo dhclient -r && sudo dhclient"
echo "   echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf"