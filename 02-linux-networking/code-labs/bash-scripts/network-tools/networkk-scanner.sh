#!/bin/bash

# ============================================
# Network Scanner Tool
# ============================================
# Scans your local network for active devices
# ============================================

echo "🔍 Network Scanner"
echo "================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Function to check command availability
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed${NC}"
        echo "Install with: $2"
        return 1
    fi
    return 0
}

# Check prerequisites
check_command "nmap" "sudo apt install nmap" || exit 1
check_command "arp" "" || exit 1

print_header "1. Network Information"

# Get default gateway
GATEWAY=$(ip route | grep default | awk '{print $3}')
echo "Default Gateway: $GATEWAY"

# Get network interface
INTERFACE=$(ip route | grep default | awk '{print $5}')
echo "Network Interface: $INTERFACE"

# Get IP address and network
IP_ADDR=$(ip -4 addr show $INTERFACE | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
NETWORK=$(ip route | grep -oP '(?<=src\s)\d+(\.\d+){3}\/\d+')
echo "Your IP: $IP_ADDR"
echo "Your Network: $NETWORK"

print_header "2. Active Hosts Scan"

# Extract network prefix (e.g., 192.168.1 from 192.168.1.10/24)
NETWORK_PREFIX=$(echo $IP_ADDR | cut -d'.' -f1-3)

echo "Scanning network: ${NETWORK_PREFIX}.0/24"
echo "This may take a minute..."

# Scan using nmap (quick scan)
echo -e "\n${YELLOW}Quick scan (common ports)...${NC}"
sudo nmap -sn ${NETWORK_PREFIX}.0/24 | grep -E "Nmap scan|MAC Address"

# Alternative: Ping sweep (if nmap not available)
echo -e "\n${YELLOW}Ping sweep...${NC}"
for i in {1..254}; do
    ping -c 1 -W 1 ${NETWORK_PREFIX}.$i &> /dev/null
    if [ $? -eq 0 ]; then
        # Try to get hostname
        hostname=$(nslookup ${NETWORK_PREFIX}.$i 2>/dev/null | grep "name" | awk -F'= ' '{print $2}' | sed 's/\.$//')
        if [ -z "$hostname" ]; then
            hostname="Unknown"
        fi
        echo -e "${GREEN}✅ ${NETWORK_PREFIX}.$i - $hostname${NC}"
    fi
done

print_header "3. ARP Table (Recently Seen Devices)"

# Show ARP table
echo "MAC Address        IP Address        Interface"
echo "--------------------------------------------"
arp -a | grep -v "incomplete" | while read line; do
    ip=$(echo $line | grep -oE '\([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\)' | tr -d '()')
    mac=$(echo $line | grep -oE '[0-9a-f:]{17}')
    iface=$(echo $line | awk '{print $NF}')
    if [ -n "$ip" ] && [ -n "$mac" ]; then
        echo "$mac  $ip  $iface"
    fi
done

print_header "4. Open Ports on Local Machine"

# Check common ports on local machine
echo "Checking common ports on $IP_ADDR..."
PORTS="22 80 443 3306 5432 8080"

for port in $PORTS; do
    nc -z localhost $port 2>/dev/null
    if [ $? -eq 0 ]; then
        service=$(grep "^$port/" /etc/services | awk '{print $1}' | head -1)
        echo -e "${GREEN}✅ Port $port ($service) is open${NC}"
    else
        echo -e "${RED}❌ Port $port is closed${NC}"
    fi
done

print_header "5. Internet Connectivity Test"

# Test internet connectivity
echo "Testing internet connectivity..."
if ping -c 2 8.8.8.8 &> /dev/null; then
    echo -e "${GREEN}✅ Internet is reachable${NC}"
    
    # Get public IP
    public_ip=$(curl -s https://api.ipify.org)
    echo "Public IP: $public_ip"
    
    # Test DNS
    if nslookup google.com &> /dev/null; then
        echo -e "${GREEN}✅ DNS is working${NC}"
    else
        echo -e "${RED}❌ DNS is not working${NC}"
    fi
else
    echo -e "${RED}❌ No internet connectivity${NC}"
fi

print_header "6. Network Statistics"

# Show network statistics
echo "Active connections:"
ss -tun | grep ESTAB | wc -l

echo -e "\nListening ports:"
ss -tuln | grep LISTEN | head -5

echo -e "\nBandwidth usage (install iftop for details):"
if command -v iftop &> /dev/null; then
    echo "Run 'sudo iftop' for live bandwidth monitoring"
else
    echo "Install iftop: sudo apt install iftop"
fi

print_header "Summary"

echo "Scan completed at: $(date)"
echo ""
echo "💡 Tips:"
echo "1. Run regularly to monitor network changes"
echo "2. Add to cron for automated scanning"
echo "3. Modify ports list for your needs"
echo "4. Use results for security auditing"
echo ""
echo "⚠️  Note: Always get permission before scanning networks you don't own!"

# Save results to file
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="network_scan_$TIMESTAMP.txt"
echo "Saving results to: $RESULTS_FILE"

{
    echo "Network Scan Results - $(date)"
    echo "================================"
    echo "Network: $NETWORK"
    echo "Gateway: $GATEWAY"
    echo "Your IP: $IP_ADDR"
    echo ""
    echo "Active hosts found during ping sweep..."
} > $RESULTS_FILE

# Append ping results
for i in {1..254}; do
    ping -c 1 -W 1 ${NETWORK_PREFIX}.$i &> /dev/null
    if [ $? -eq 0 ]; then
        echo "${NETWORK_PREFIX}.$i" >> $RESULTS_FILE
    fi
done

echo -e "\n${GREEN}✅ Scan completed! Results saved to $RESULTS_FILE${NC}"