#!/bin/bash

# ============================================
# DNS Troubleshooter
# ============================================
# Diagnoses DNS issues step by step
# ============================================

echo "🌐 DNS Troubleshooter"
echo "===================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Test domains
TEST_DOMAINS=("google.com" "github.com" "aws.amazon.com" "localhost")

print_section "1. Basic Connectivity Test"

# Test if we have internet
if ping -c 2 8.8.8.8 &> /dev/null; then
    print_success "Internet connectivity OK"
else
    print_error "No internet connectivity"
    echo "Fix network connection first"
    exit 1
fi

print_section "2. Local DNS Configuration"

# Check /etc/resolv.conf
echo "Checking /etc/resolv.conf..."
if [ -f /etc/resolv.conf ]; then
    cat /etc/resolv.conf | grep -v "^#" | grep -v "^$"
    
    # Count nameservers
    NS_COUNT=$(cat /etc/resolv.conf | grep "nameserver" | wc -l)
    if [ $NS_COUNT -gt 0 ]; then
        print_success "Found $NS_COUNT nameserver(s)"
    else
        print_error "No nameservers configured"
    fi
else
    print_error "/etc/resolv.conf not found"
fi

# Check /etc/hosts
echo -e "\nChecking /etc/hosts for local overrides..."
grep -v "^#" /etc/hosts | grep -v "^$" | head -5

print_section "3. DNS Resolution Test"

# Test each domain
for domain in "${TEST_DOMAINS[@]}"; do
    echo -n "Testing $domain... "
    
    # Try nslookup first
    if nslookup $domain &> /dev/null; then
        print_success "Resolves"
        
        # Get IP address
        ip=$(nslookup $domain | grep "Address:" | tail -1 | awk '{print $2}')
        echo "   IP Address: $ip"
        
        # Test connectivity to the IP
        if ping -c 1 -W 1 $ip &> /dev/null; then
            echo "   Reachable: Yes"
        else
            echo "   Reachable: No"
        fi
    else
        print_error "Failed to resolve"
    fi
done

print_section "4. Query Different DNS Servers"

DNS_SERVERS=(
    "Google:8.8.8.8"
    "Cloudflare:1.1.1.1"
    "OpenDNS:208.67.222.222"
    "Your ISP:(from resolv.conf)"
)

for server in "${DNS_SERVERS[@]}"; do
    name=$(echo $server | cut -d':' -f1)
    ip=$(echo $server | cut -d':' -f2)
    
    if [ "$ip" == "(from resolv.conf)" ]; then
        # Use first nameserver from resolv.conf
        ip=$(cat /etc/resolv.conf | grep nameserver | head -1 | awk '{print $2}')
        if [ -z "$ip" ]; then
            continue
        fi
    fi
    
    echo -n "Testing with $name ($ip)... "
    if nslookup google.com $ip &> /dev/null; then
        print_success "Works"
        
        # Get response time
        time=$(dig @$ip google.com | grep "Query time:" | awk '{print $4 " ms"}')
        echo "   Response time: $time"
    else
        print_error "Failed"
    fi
done

print_section "5. DNS Record Types"

# Check different record types for a domain
DOMAIN_TO_TEST="google.com"
RECORD_TYPES=("A" "AAAA" "MX" "NS" "TXT")

echo "Checking record types for $DOMAIN_TO_TEST:"

for record in "${RECORD_TYPES[@]}"; do
    echo -n "  $record records: "
    if dig $DOMAIN_TO_TEST $record +short &> /dev/null; then
        print_success "Found"
        dig $DOMAIN_TO_TEST $record +short | head -2 | while read line; do
            echo "    $line"
        done
    else
        print_error "None"
    fi
done

print_section "6. DNS Cache Check"

# Check if DNS caching is involved
echo "Checking for DNS caching..."

# Systemd-resolve (common on Ubuntu)
if command -v systemd-resolve &> /dev/null; then
    echo "Systemd-resolve status:"
    systemd-resolve --status | grep "DNS Servers" -A2
fi

# Try to flush cache if possible
echo -e "\nTo flush DNS cache:"
echo "  Ubuntu: sudo systemd-resolve --flush-caches"
echo "  macOS: sudo dscacheutil -flushcache"
echo "  Windows: ipconfig /flushdns"

print_section "7. Common Issues and Solutions"

echo "🔧 Common DNS issues and fixes:"
echo ""
echo "1. Can't resolve any domains:"
echo "   - Check /etc/resolv.conf"
echo "   - Try: sudo dhclient -r && sudo dhclient"
echo ""
echo "2. Can resolve some domains but not others:"
echo "   - Check firewall blocking DNS (port 53)"
echo "   - Try different DNS server"
echo ""
echo "3. Slow DNS resolution:"
echo "   - Use faster DNS like 8.8.8.8 or 1.1.1.1"
echo "   - Check network latency"
echo ""
echo "4. DNS timeout:"
echo "   - Check if DNS server is reachable: ping 8.8.8.8"
echo "   - Check if port 53 is open: nc -zv 8.8.8.8 53"
echo ""
echo "5. Wrong IP returned:"
echo "   - Clear DNS cache"
echo "   - Check /etc/hosts for overrides"
echo "   - Check for DNS hijacking"

print_section "8. Quick Fixes to Try"

echo "Try these commands if DNS is not working:"

cat << 'EOF'
# 1. Restart networking
sudo systemctl restart networking   # Or NetworkManager

# 2. Use Google DNS temporarily
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf

# 3. Test with dig (more detailed)
dig google.com
dig google.com +trace

# 4. Check DNS response time
time nslookup google.com

# 5. Test with different tools
host google.com
drill google.com
EOF

print_section "Summary"

echo "DNS troubleshooting completed at: $(date)"
echo ""
echo "📋 Summary:"
echo "  - Internet connectivity: $(ping -c 1 8.8.8.8 &>/dev/null && echo 'OK' || echo 'FAIL')"
echo "  - DNS resolution: $(nslookup google.com &>/dev/null && echo 'OK' || echo 'FAIL')"
echo "  - Configured nameservers: $NS_COUNT"
echo ""
echo "💡 Next steps:"
echo "  1. If DNS fails, try using 8.8.8.8 as nameserver"
echo "  2. Check firewall rules for port 53"
echo "  3. Look for network misconfiguration"
echo ""
echo "Results saved to: dns_diagnosis_$(date +%Y%m%d_%H%M%S).log"

# Save detailed results
{
    echo "DNS Troubleshooter Report"
    echo "========================="
    echo "Date: $(date)"
    echo ""
    echo "1. /etc/resolv.conf:"
    cat /etc/resolv.conf
    echo ""
    echo "2. DNS Resolution Test:"
    for domain in "${TEST_DOMAINS[@]}"; do
        echo "  $domain:"
        nslookup $domain 2>&1 | grep -A2 "Name:"
    done
} > "dns_diagnosis_$(date +%Y%m%d_%H%M%S).log"

echo -e "\n${GREEN}✅ Troubleshooting completed!${NC}"