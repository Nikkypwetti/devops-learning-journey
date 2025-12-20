# 🌐 Networking Concepts Cheatsheet

## 📊 **OSI Model vs TCP/IP Model**

### **OSI Model (7 Layers)**

Layer 7: Application - HTTP, FTP, DNS, SMTP
Layer 6: Presentation - SSL/TLS, Encryption
Layer 5: Session - Sessions, Authentication
Layer 4: Transport - TCP, UDP, Ports
Layer 3: Network - IP, Routers, IP Addresses
Layer 2: Data Link - MAC Addresses, Switches
Layer 1: Physical - Cables, Hubs, Signals
text


**Mnemonic:** Please Do Not Throw Sausage Pizza Away

### **TCP/IP Model (4 Layers)**

Application Layer - OSI 5+6+7 (HTTP, FTP, DNS)
Transport Layer - OSI 4 (TCP, UDP)
Internet Layer - OSI 3 (IP, ICMP)
Network Access - OSI 1+2 (Ethernet, WiFi)
text


## 🔢 **IP Addressing**

### **IPv4 Address Classes**

Class A: 1.0.0.0 to 126.255.255.255 (Large networks)
Class B: 128.0.0.0 to 191.255.255.255 (Medium networks)
Class C: 192.0.0.0 to 223.255.255.255 (Small networks)
Class D: 224.0.0.0 to 239.255.255.255 (Multicast)
Class E: 240.0.0.0 to 255.255.255.255 (Experimental)
text


### **Private IP Ranges (RFC 1918)**

10.0.0.0/8 - 10.0.0.0 to 10.255.255.255
172.16.0.0/12 - 172.16.0.0 to 172.31.255.255
192.168.0.0/16 - 192.168.0.0 to 192.168.255.255
text


### **Special IP Addresses**

127.0.0.1 - Localhost (Loopback)
169.254.0.0/16 - APIPA (Automatic Private IP)
0.0.0.0 - Default route/any address
255.255.255.255 - Broadcast address
text


## 🎯 **Subnetting Quick Reference**

### **CIDR Notation to Subnet Mask**

CIDR Subnet Mask Hosts Networks
/24 255.255.255.0 254 Small
/25 255.255.255.128 126
/26 255.255.255.192 62
/27 255.255.255.224 30
/28 255.255.255.240 14 Very Small
/29 255.255.255.248 6
/30 255.255.255.252 2 Point-to-point
/32 255.255.255.255 1 Single Host
text


### **Common Subnets**

/8 255.0.0.0 16,777,214 hosts
/16 255.255.0.0 65,534 hosts
/24 255.255.255.0 254 hosts (Most common)
/25 255.255.255.128 126 hosts
/26 255.255.255.192 62 hosts
/27 255.255.255.224 30 hosts
text


### **Subnet Calculation Examples**

Network: 192.168.1.0/24
Subnet Mask: 255.255.255.0
Network Address: 192.168.1.0
First Host: 192.168.1.1
Last Host: 192.168.1.254
Broadcast: 192.168.1.255
Usable Hosts: 254

Network: 10.0.0.0/16
Subnet Mask: 255.255.0.0
Network Address: 10.0.0.0
First Host: 10.0.0.1
Last Host: 10.0.255.254
Broadcast: 10.0.255.255
Usable Hosts: 65,534
text


## 🚪 **Common Ports and Protocols**

### **Well-Known Ports (0-1023)**

20/21 - FTP (File Transfer Protocol)
22 - SSH (Secure Shell)
23 - Telnet
25 - SMTP (Simple Mail Transfer)
53 - DNS (Domain Name System)
67/68 - DHCP (Dynamic Host Configuration)
80 - HTTP (HyperText Transfer Protocol)
110 - POP3 (Post Office Protocol)
123 - NTP (Network Time Protocol)
143 - IMAP (Internet Message Access)
161/162 - SNMP (Simple Network Management)
443 - HTTPS (HTTP Secure)
465 - SMTPS (SMTP Secure)
587 - SMTP Submission
993 - IMAPS (IMAP Secure)
995 - POP3S (POP3 Secure)
text


### **Registered Ports (1024-49151)**

1433 - MS SQL Server
1521 - Oracle Database
2049 - NFS (Network File System)
3306 - MySQL Database
3389 - RDP (Remote Desktop Protocol)
5432 - PostgreSQL Database
5900 - VNC (Virtual Network Computing)
6379 - Redis Database
8080 - HTTP Alternate
8443 - HTTPS Alternate
27017 - MongoDB Database
text


### **Protocol Comparison: TCP vs UDP**

TCP (Transmission Control Protocol):
✓ Connection-oriented
✓ Reliable delivery
✓ Error checking
✓ Flow control
✓ Ordered delivery
✗ Slower
✗ More overhead
Use cases: Web, Email, File Transfer

UDP (User Datagram Protocol):
✓ Connectionless
✓ Faster
✓ Less overhead
✗ Unreliable
✗ No error checking
✗ No ordering
Use cases: Video streaming, DNS, Gaming
text


## 🌐 **DNS (Domain Name System)**

### **DNS Record Types**

A Record - Maps hostname to IPv4 address
AAAA Record - Maps hostname to IPv6 address
CNAME Record - Alias of another domain name
MX Record - Mail exchange server
TXT Record - Text information (SPF, DKIM)
NS Record - Name server for domain
SOA Record - Start of Authority (zone info)
PTR Record - Reverse DNS (IP to name)
SRV Record - Service location
text


### **DNS Resolution Process**

    Check local cache

    Check hosts file (/etc/hosts)

    Query configured DNS server

    Root servers -> TLD servers -> Authoritative servers

    Cache the result

text


### **DNS Tools**
```bash
# Query DNS records
nslookup example.com
dig example.com
dig example.com A          # Specific record type
dig example.com MX
dig @8.8.8.8 example.com   # Use specific DNS server
dig -x 8.8.8.8             # Reverse lookup

# Check DNS configuration
cat /etc/resolv.conf       # DNS servers
cat /etc/hosts             # Local hostnames
systemd-resolve --status   # Systemd DNS

🔒 HTTP/HTTPS
HTTP Status Codes
text

1xx - Informational
  100 Continue
  101 Switching Protocols

2xx - Success
  200 OK
  201 Created
  204 No Content

3xx - Redirection
  301 Moved Permanently
  302 Found
  304 Not Modified

4xx - Client Error
  400 Bad Request
  401 Unauthorized
  403 Forbidden
  404 Not Found
  429 Too Many Requests

5xx - Server Error
  500 Internal Server Error
  502 Bad Gateway
  503 Service Unavailable
  504 Gateway Timeout

HTTP Methods
text

GET     - Retrieve resource
POST    - Submit data to server
PUT     - Update resource
DELETE  - Delete resource
PATCH   - Partial update
HEAD    - Get headers only
OPTIONS - Get allowed methods

HTTPS Components
text

HTTPS = HTTP + TLS/SSL
Port: 443 (default)

Components:
1. Certificate (issued by CA)
2. Public/Private key pair
3. TLS handshake process
4. Encrypted communication

🔧 Network Troubleshooting Commands
Connectivity Testing
bash

# Basic ping
ping 8.8.8.8
ping -c 4 google.com        # Send 4 packets
ping -i 2 google.com        # 2 second interval

# Advanced testing
ping -M do google.com       # Don't fragment
ping -s 1472 google.com     # Specific packet size
ping -f google.com          # Flood ping (admin only)

# Path tracing
traceroute google.com
mtr google.com              # My traceroute (combines ping+traceroute)
tracepath google.com        # Alternative to traceroute

Port and Service Testing
bash

# Check if port is open
nc -zv hostname 22          # Test SSH port
telnet hostname 80          # Test HTTP port

# Scan ports
nmap -sS hostname           # TCP SYN scan
nmap -sU hostname           # UDP scan
nmap -sV hostname           # Version detection
nmap -p 1-1000 hostname     # Specific port range
nmap -O hostname            # OS detection

# Service testing
curl -I http://hostname     # HTTP headers only
curl -v http://hostname     # Verbose output
wget http://hostname/file   # Download file

Network Configuration
bash

# Modern (ip command)
ip addr show                # Show IP addresses
ip link show                # Show network interfaces
ip route show               # Show routing table
ip neigh show               # Show ARP table

# Legacy (ifconfig)
ifconfig                    # Show interfaces
ifconfig eth0 up            # Bring interface up
ifconfig eth0 down          # Bring interface down
ifconfig eth0 192.168.1.10  # Set IP address

# Routing
route -n                    # Show routing table
route add default gw 192.168.1.1  # Add default gateway
route del default gw 192.168.1.1  # Remove gateway

Packet Analysis
bash

# tcpdump basics
sudo tcpdump -i eth0        # Capture on interface
sudo tcpdump port 80        # Capture port 80 traffic
sudo tcpdump host 8.8.8.8   # Capture traffic to/from host
sudo tcpdump -w file.pcap   # Save to file
sudo tcpdump -r file.pcap   # Read from file
sudo tcpdump -n             # Don't resolve names
sudo tcpdump -c 10          # Capture 10 packets

# Wireshark filters
tcp.port == 22              # SSH traffic
ip.src == 192.168.1.1       # Source IP
http.request                # HTTP requests
dns                         # DNS traffic

🏗️ Network Devices
Hub vs Switch vs Router
text

Hub (Layer 1):
- Broadcasts to all ports
- No intelligence
- Collision domain: All ports

Switch (Layer 2):
- Learns MAC addresses
- Forwards based on MAC
- Each port is collision domain
- VLAN capable

Router (Layer 3):
- Routes between networks
- Uses IP addresses
- NAT, Firewall capabilities
- Connects different networks

VLAN (Virtual LAN)
text

Purpose: Logical segmentation of physical network
Benefits: Security, Performance, Management
Types:
  Access Port: Single VLAN
  Trunk Port: Multiple VLANs (802.1Q tagging)
Commands:
  show vlan brief          # View VLANs
  vlan 10                  # Create VLAN 10
  switchport access vlan 10 # Assign port to VLAN

🔐 Network Security
Firewall Types
text

Packet Filtering: Based on IP/Port (Stateless)
Stateful Inspection: Tracks connections
Proxy Firewall: Intercepts all traffic
Next-Gen Firewall: Deep packet inspection

Common Attacks
text

DoS/DDoS      - Overwhelm resources
MITM          - Intercept communication
DNS Spoofing  - Redirect to malicious site
ARP Poisoning - Redirect traffic
Port Scanning - Discover open ports

Security Best Practices
text

1. Use strong passwords
2. Enable firewalls
3. Regular updates
4. Disable unused services
5. Use VPN for remote access
6. Implement network segmentation
7. Monitor logs
8. Regular security audits

📡 Wireless Networking
WiFi Standards
text

802.11a - 5 GHz, 54 Mbps
802.11b - 2.4 GHz, 11 Mbps
802.11g - 2.4 GHz, 54 Mbps
802.11n - 2.4/5 GHz, 600 Mbps (WiFi 4)
802.11ac - 5 GHz, 1.3 Gbps (WiFi 5)
802.11ax - 2.4/5/6 GHz, 10 Gbps (WiFi 6)

WiFi Security
text

WEP - Weak, easily cracked
WPA - Better but vulnerabilities
WPA2 - Current standard (AES encryption)
WPA3 - Latest standard (Enhanced security)

💾 Network Services
DHCP (Dynamic Host Configuration)
text

Purpose: Automatic IP assignment
Process: DORA (Discover, Offer, Request, Acknowledge)
Ports: 67 (Server), 68 (Client)
Lease Time: Default 24 hours

NAT (Network Address Translation)
text

Purpose: Share single public IP
Types:
  Static NAT - One-to-one mapping
  Dynamic NAT - Pool of addresses
  PAT (Port Address Translation) - Multiple hosts, one IP

VPN (Virtual Private Network)
text

Purpose: Secure remote access
Types:
  Site-to-Site - Connect networks
  Remote Access - Connect users
Protocols: OpenVPN, IPsec, WireGuard, L2TP

📊 Network Monitoring
Bandwidth Monitoring
bash

# Real-time monitoring
iftop                          # Interface top
nload                          # Network load
bmon                           # Bandwidth monitor

# Historical data
vnstat                         # Network traffic monitor
sar -n DEV 1 3                 # Network stats

Connection Monitoring
bash

# Active connections
netstat -ant                   # All TCP connections
ss -s                          # Socket statistics
lsof -i                        # Open network connections

# Connection tracking
conntrack -L                   # Track connections
conntrack -E                   # Events in real-time

🎯 Troubleshooting Flow
Step-by-Step Diagnosis
text

1. Ping localhost (127.0.0.1)     - TCP/IP stack working?
2. Ping gateway                   - Local network working?
3. Ping external IP (8.8.8.8)     - Internet connectivity?
4. Ping external domain (google.com) - DNS working?
5. Check specific service port    - Service responding?
6. Check firewall rules           - Traffic allowed?
7. Check routing table            - Correct routes?
8. Check DNS configuration        - Proper resolution?

Common Issues and Solutions
text

No Internet:
✓ Check physical connection
✓ Verify IP configuration
✓ Test with different DNS
✓ Check firewall settings

Slow Network:
✓ Check bandwidth usage
✓ Look for bottlenecks
✓ Test with different devices
✓ Check for interference (wireless)

DNS Issues:
✓ Flush DNS cache
✓ Use alternative DNS (8.8.8.8)
✓ Check /etc/resolv.conf
✓ Test with nslookup/dig

Connection Drops:
✓ Check cable/connector
✓ Update drivers/firmware
✓ Check for IP conflicts
✓ Monitor for interference

📚 Network Reference Tables
Ethernet Cable Standards
text

Cat5: 100 Mbps, 100 MHz
Cat5e: 1 Gbps, 100 MHz
Cat6: 1 Gbps, 250 MHz
Cat6a: 10 Gbps, 500 MHz
Cat7: 10 Gbps, 600 MHz
Cat8: 40 Gbps, 2000 MHz

Maximum Cable Lengths
text

Ethernet (Cat5/6): 100 meters
Fiber Optic: 2km to 40km
WiFi 2.4 GHz: ~50 meters indoor
WiFi 5 GHz: ~30 meters indoor

Data Rate Conversions
text

1 Mbps = 1,000,000 bits/second
1 MBps = 8,000,000 bits/second
1 Gbps = 1,000 Mbps
1 Byte = 8 bits

🔧 Useful Networking Tools
Linux Networking Commands
bash

# Network manager
nmcli                         # Network Manager CLI
nmtui                         # Network Manager TUI

# Wireless tools
iwconfig                      # Wireless configuration
iwlist                        # Wireless information
wpa_supplicant               # WPA authentication

# Bridge management
brctl show                    # Show bridges
brctl addbr br0              # Add bridge
brctl addif br0 eth0         # Add interface to bridge

Third-Party Tools
text

Wireshark     - Packet analysis
Nmap          - Network scanning
Netcat        - Swiss army knife
Iperf         - Bandwidth testing
MTR           - Advanced traceroute
Ettercap      - MITM attacks
Aircrack-ng   - Wireless security

🎓 Quick Reference
Essential Commands:

    Connectivity: ping, traceroute

    DNS: nslookup, dig

    Configuration: ip, ifconfig

    Ports: netstat, ss, nmap

    Analysis: tcpdump, wireshark

Key Files:

    /etc/hosts - Local hostnames

    /etc/resolv.conf - DNS servers

    /etc/network/interfaces - Network config (Debian)

    /etc/sysconfig/network-scripts/ - Network config (RHEL)

Important Protocols:

    HTTP/HTTPS: Web traffic

    DNS: Name resolution

    DHCP: Automatic IP assignment

    SSH: Secure remote access

    TCP/UDP: Transport protocols

Remember: Networking is about layers. Start troubleshooting from Layer 1 (Physical) and work your way up!