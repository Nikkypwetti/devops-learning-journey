#!/bin/bash
# Week 3: Networking Fundamentals Practice

echo "=========================================="
echo "Week 3: Networking Fundamentals"
echo "=========================================="

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_header "Day 15: OSI Model Reference"
cat << 'EOF'
OSI Model - 7 Layers:
1. Physical    - Cables, signals, hardware
2. Data Link   - MAC addresses, switches
3. Network     - IP addresses, routers
4. Transport   - TCP/UDP, ports
5. Session     - Connections, sessions
6. Presentation- Encryption, compression
7. Application - HTTP, DNS, FTP

TCP/IP Model - 4 Layers:
1. Link        - OSI 1+2
2. Internet    - OSI 3
3. Transport   - OSI 4
4. Application - OSI 5+6+7
EOF

print_header "Day 16: IP Subnetting Practice"
echo "Practice problems:"
echo "1. Network: 192.168.1.0/24"
echo "   Subnet mask: 255.255.255.0"
echo "   Hosts: 254 (192.168.1.1 - 192.168.1.254)"
echo ""
echo "2. Network: 10.0.0.0/16"
echo "   Subnet mask: 255.255.0.0"
echo "   Hosts: 65534"
echo ""
echo "Private IP Ranges:"
echo "• 10.0.0.0/8     (10.0.0.0 - 10.255.255.255)"
echo "• 172.16.0.0/12  (172.16.0.0 - 172.31.255.255)"
echo "• 192.168.0.0/16 (192.168.0.0 - 192.168.255.255)"

print_header "Day 17: DNS Operations"
echo "Testing DNS resolution:"
echo "1. Resolve google.com:"
nslookup google.com 8.8.8.8 2>/dev/null | grep -A1 "Name:"
echo ""
echo "2. Check local DNS configuration:"
cat /etc/resolv.conf 2>/dev/null | grep nameserver
echo ""
echo "Common DNS record types:"
echo "• A     - IPv4 address"
echo "• AAAA  - IPv6 address"
echo "• CNAME - Canonical name (alias)"
echo "• MX    - Mail exchange"
echo "• TXT   - Text records"

print_header "Day 18: HTTP/HTTPS Testing"
echo "Testing web protocols with curl:"
echo "1. HTTP request to example.com:"
curl -I http://example.com 2>/dev/null | head -5
echo ""
echo "2. HTTPS request to google.com:"
curl -I https://google.com 2>/dev/null | head -5
echo ""
echo "Common HTTP status codes:"
echo "• 200 - OK"
echo "• 301 - Moved Permanently"
echo "• 404 - Not Found"
echo "• 500 - Internal Server Error"

print_header "Day 19: Network Troubleshooting Tools"
echo "Available network tools:"
which ping >/dev/null 2>&1 && echo -e "${GREEN}✓ ping${NC}" || echo -e "${RED}✗ ping not found${NC}"
which traceroute >/dev/null 2>&1 && echo -e "${GREEN}✓ traceroute${NC}" || echo -e "${RED}✗ traceroute not found${NC}"
which netstat >/dev/null 2>&1 && echo -e "${GREEN}✓ netstat${NC}" || echo -e "${RED}✗ netstat not found${NC}"
which ss >/dev/null 2>&1 && echo -e "${GREEN}✓ ss${NC}" || echo -e "${RED}✗ ss not found${NC}"
which tcpdump >/dev/null 2>&1 && echo -e "${GREEN}✓ tcpdump${NC}" || echo -e "${RED}✗ tcpdump not found${NC}"

echo ""
echo "Testing connectivity:"
ping -c 2 8.8.8.8 2>/dev/null && echo -e "${GREEN}✓ Internet connectivity OK${NC}" || echo -e "${RED}✗ No internet connectivity${NC}"

print_header "Day 20: Port Scanning Simulation"
echo "Common ports and services:"
cat << 'EOF'
PORT    SERVICE     PROTOCOL    PURPOSE
22      SSH         TCP         Secure Shell
53      DNS         TCP/UDP     Domain Name System
80      HTTP        TCP         Web Traffic
443     HTTPS       TCP         Secure Web Traffic
25      SMTP        TCP         Email Sending
110     POP3        TCP         Email Retrieval
143     IMAP        TCP         Email Retrieval
3306    MySQL       TCP         Database
3389    RDP         TCP         Remote Desktop
EOF

echo ""
echo "Checking open ports on localhost:"
netstat -tulpn 2>/dev/null | grep LISTEN | head -5 || ss -tulpn 2>/dev/null | head -5

print_header "Day 21: Home Network Lab Design"
echo "Sample home lab design:"
cat << 'EOF'
Network: 192.168.100.0/24
Gateway: 192.168.100.1
DHCP Range: 192.168.100.100-200

Devices:
1. Router/Firewall: 192.168.100.1
2. Main Server: 192.168.100.10
   - DNS (dnsmasq)
   - DHCP server
   - File server (Samba)
3. Web Server: 192.168.100.20
   - Apache/Nginx
   - PHP/Node.js
4. Database Server: 192.168.100.30
   - MySQL/PostgreSQL
5. Client PCs: 192.168.100.100+
EOF

print_header "Week 3 Cheatsheet"
cat > ~/networking-week3-cheatsheet.md << 'EOF'
# Networking Week 3 Cheatsheet

## OSI Model Mnemonic
Please Do Not Throw Sausage Pizza Away
1. Physical
2. Data Link
3. Network
4. Transport
5. Session
6. Presentation
7. Application

## Subnetting Quick Reference
CIDR    Subnet Mask        Hosts
/24     255.255.255.0      254
/25     255.255.255.128    126
/26     255.255.255.192    62
/27     255.255.255.224    30
/28     255.255.255.240    14
/29     255.255.255.248    6
/30     255.255.255.252    2

## DNS Commands
- `nslookup domain` - Query DNS
- `dig domain` - Detailed DNS query
- `host domain` - Simple DNS lookup
- `cat /etc/resolv.conf` - View DNS config

## Network Testing
- `ping host` - Test connectivity
- `traceroute host` - Trace network path
- `mtr host` - Advanced traceroute
- `netstat -tulpn` - Show listening ports
- `ss -tulpn` - Modern socket statistics

## HTTP/HTTPS
- `curl -I url` - Show headers only
- `curl -v url` - Verbose output
- `wget url` - Download file
- `openssl s_client -connect host:443` - Test SSL

## Common Ports
- 22: SSH
- 53: DNS
- 80: HTTP
- 443: HTTPS
- 25: SMTP
- 110: POP3
- 143: IMAP
- 3306: MySQL
- 3389: RDP

## IP Addressing
Private Ranges:
- 10.0.0.0/8
- 172.16.0.0/12
- 192.168.0.0/16

Loopback: 127.0.0.1/8
Link-local: 169.254.0.0/16
EOF

echo -e "\n${GREEN}Cheatsheet saved to: ~/networking-week3-cheatsheet.md${NC}"
echo -e "\n${GREEN}Week 3 practice completed!${NC}"