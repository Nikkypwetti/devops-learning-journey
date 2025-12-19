# Week 3 Summary: Networking Fundamentals

## 📊 Progress
**Dates:** 2024-02-15 to 2024-02-21  
**Hours Studied:** 14 hours  
**Topics Covered:** 7/7  
**Labs Completed:** 9/9

## 🎯 Learning Objectives Achieved
- [x] Understand OSI and TCP/IP models
- [x] Master IP addressing and subnetting
- [x] Learn DNS fundamentals and operations
- [x] Understand HTTP/HTTPS protocols
- [x] Use network troubleshooting tools
- [x] Identify common ports and protocols
- [x] Build a home network lab

## 🏆 Key Skills Developed
### OSI Model Layers
1. **Physical** - Cables, signals
2. **Data Link** - MAC addresses, switches
3. **Network** - IP addresses, routers
4. **Transport** - TCP/UDP, ports
5. **Session** - Connections, sessions
6. **Presentation** - Data formatting
7. **Application** - HTTP, DNS, FTP

### IP Subnetting
- CIDR notation: `/24`, `/16`, `/8`
- Subnet mask calculation
- Network vs Host addresses
- Private IP ranges:
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16

### DNS Operations
- A Records (IPv4)
- AAAA Records (IPv6)
- CNAME (Aliases)
- MX (Mail Exchange)
- TXT (Text records)

## 📈 Progress Metrics
| Day | Topic | Labs Completed | Key Concepts Learned |
|-----|-------|----------------|---------------------|
| 15 | OSI/TCP/IP Models | 3 | 7 Layers, TCP/IP stack |
| 16 | IP Subnetting | 5 | CIDR, subnet masks, calculations |
| 17 | DNS Fundamentals | 4 | Records, resolution, tools |
| 18 | HTTP/HTTPS | 3 | Protocols, status codes, headers |
| 19 | Network Tools | 6 | ping, traceroute, netstat, tcpdump |
| 20 | Ports & Protocols | 7 | Well-known ports, nmap scanning |
| 21 | Review Project | 1 | Home Network Lab Setup |

## 🚧 Challenges Faced
1. **Subnetting Calculations:** Binary to decimal conversions
   - **Solution:** Used online calculators initially, then practiced manually
2. **DNS Resolution Process:** Understanding recursive vs iterative queries
   - **Solution:** Created flowchart of DNS resolution steps
3. **Firewall Rules:** Understanding iptables/ufw syntax
   - **Solution:** Started with ufw (simpler), then moved to iptables

## 💡 Key Insights
1. OSI model is theoretical; TCP/IP is practical implementation
2. Every device needs unique IP on network (NAT helps with private IPs)
3. DNS is like phonebook for internet - translates names to IPs
4. HTTPS = HTTP + TLS encryption
5. Well-known ports: 22(SSH), 80(HTTP), 443(HTTPS), 53(DNS)

## 🔗 Resources Used
- [TryHackMe Networking Rooms](https://tryhackme.com/module/network-fundamentals)
- [Subnetting Practice](https://www.subnetting.org/)
- [Professor Messer Network+](https://www.professormesser.com/network-plus/n10-008/n10-008-training-course/)
- [Wireshark Tutorials](https://www.wireshark.org/docs/)

## 🎯 Next Week Goals
1. Configure Linux network interfaces
2. Master SSH key authentication
3. Set up firewall rules
4. Integrate Linux with AWS VPC

## 📚 Weekly Project
Completed: **Home Network Lab** (`projects/home-lab/`)
- Designed network topology
- Configured VLANs (simulated)
- Set up DNS server (dnsmasq)
- Created network documentation

---
*Week 3 completed! Ready for Linux networking and AWS integration.*