# 🐧 Linux Commands Cheatsheet

## 📁 **File System Navigation**

### Basic Navigation
```bash
pwd                     # Print working directory
ls                      # List files
ls -la                  # List all files with details
ls -lh                  # Human readable sizes
ls -t                   # Sort by time
cd /path                # Change directory
cd ~                    # Go to home directory
cd ..                   # Go up one level
cd -                    # Go to previous directory

File Operations
bash

touch file.txt          # Create empty file
cat file.txt            # Display file content
less file.txt           # View file page by page
head -n 10 file.txt     # Show first 10 lines
tail -n 10 file.txt     # Show last 10 lines
tail -f file.txt        # Follow file (live updates)

cp source dest          # Copy file
cp -r source dest       # Copy directory recursively
mv source dest          # Move/rename file
rm file.txt             # Remove file
rm -r directory         # Remove directory recursively
rm -f file              # Force remove
mkdir folder            # Create directory
rmdir folder            # Remove empty directory

File Permissions
bash

chmod 755 file.sh       # rwxr-xr-x
chmod 644 file.txt      # rw-r--r--
chmod +x script.sh      # Add execute permission
chmod -w file.txt       # Remove write permission

chown user:group file   # Change owner and group
chown user file         # Change owner
chgrp group file        # Change group

# Permission values:
# 0 = ---     4 = r--     5 = r-x     6 = rw-     7 = rwx
# User Group Others
# 7   5   5   = rwxr-xr-x
# 6   4   4   = rw-r--r--

Text Processing
bash

# grep - Search patterns
grep "pattern" file              # Basic search
grep -i "pattern" file           # Case insensitive
grep -r "pattern" dir/           # Recursive search
grep -v "pattern" file           # Invert match
grep -n "pattern" file           # Show line numbers
grep -c "pattern" file           # Count matches
grep -E "pattern1|pattern2" file # Extended regex

# sed - Stream editor
sed 's/old/new/g' file           # Replace globally
sed 's/old/new/2' file           # Replace 2nd occurrence
sed '/pattern/d' file            # Delete lines with pattern
sed -n '5,10p' file              # Print lines 5-10
sed -i.bak 's/old/new/g' file    # In-place edit with backup

# awk - Text processing
awk '{print $1}' file            # Print first column
awk -F',' '{print $2}' file      # Use comma as delimiter
awk 'NR>1' file                  # Skip header line
awk '$3 > 100 {print $0}' file   # Filter based on column
awk '{sum+=$1} END {print sum}'  # Sum column

Process Management
bash

ps                         # Current processes
ps aux                     # All processes with details
ps -ef                     # Full format listing
ps aux | grep process      # Find specific process
ps aux --sort=-%cpu        # Sort by CPU usage
ps aux --sort=-%mem        # Sort by memory usage

top                        # Interactive process viewer
htop                       # Enhanced top (install separately)
pstree                     # Show process tree

kill PID                   # Terminate process (SIGTERM)
kill -9 PID                # Force kill (SIGKILL)
kill -15 PID               # Graceful termination
kill -STOP PID             # Pause process
kill -CONT PID             # Continue paused process
killall process_name       # Kill all processes by name

jobs                       # List background jobs
fg %1                      # Bring job 1 to foreground
bg %1                      # Send job 1 to background
command &                  # Run command in background
Ctrl+Z                     # Suspend foreground job
Ctrl+C                     # Terminate foreground job

System Information
bash

uname -a                   # All system information
hostname                   # System hostname
whoami                     # Current user
id                         # User and group info
w                          # Who is logged in
uptime                     # System uptime and load
date                       # Current date and time
cal                        # Calendar

# Hardware Information
lscpu                      # CPU information
lsblk                      # Block devices
lsusb                      # USB devices
lspci                      # PCI devices
free -h                    # Memory usage
df -h                      # Disk usage
du -sh directory           # Directory size

# Network Information
ifconfig                   # Network interfaces (deprecated)
ip addr show               # Modern alternative
ip route show              # Routing table
netstat -tulpn             # Listening ports
ss -tulpn                  # Modern socket statistics

Package Management
bash

# Debian/Ubuntu (apt)
sudo apt update            # Update package lists
sudo apt upgrade           # Upgrade packages
sudo apt install package   # Install package
sudo apt remove package    # Remove package
sudo apt autoremove        # Remove unused packages
sudo apt search pattern    # Search packages
sudo apt show package      # Show package info

# RHEL/CentOS (yum/dnf)
sudo yum install package   # Install package
sudo yum update            # Update packages
sudo yum remove package    # Remove package
sudo yum search pattern    # Search packages
sudo yum info package      # Package information

# Arch (pacman)
sudo pacman -S package     # Install package
sudo pacman -Syu           # Update system
sudo pacman -R package     # Remove package
sudo pacman -Ss pattern    # Search packages

User Management
bash

# User Management
sudo useradd username      # Create user
sudo usermod -aG group username  # Add user to group
sudo userdel username      # Delete user
sudo passwd username       # Change password
sudo chage username        # Password aging

# Group Management
sudo groupadd groupname    # Create group
sudo groupmod -n newname oldname  # Rename group
sudo groupdel groupname    # Delete group

# Sudo Configuration
sudo visudo                # Edit sudoers file
# Add: username ALL=(ALL) NOPASSWD:ALL  # Passwordless sudo

Disk Management
bash

# Disk Information
fdisk -l                   # List partitions
lsblk                      # List block devices
df -h                      # Disk usage (human readable)
du -sh *                   # Directory sizes
du -h --max-depth=1        # One level deep

# Filesystem Operations
mkfs.ext4 /dev/sda1        # Create ext4 filesystem
mkfs.xfs /dev/sda1         # Create XFS filesystem
fsck /dev/sda1             # Check filesystem

# Mounting
mount /dev/sda1 /mnt       # Mount partition
umount /mnt                # Unmount
mount -a                   # Mount all from /etc/fstab
blkid                      # Show UUIDs for mounting

# Swap Management
swapon --show              # Show swap usage
sudo swapon /dev/sda2      # Enable swap
sudo swapoff /dev/sda2     # Disable swap

Service Management (systemd)
bash

# Service Control
sudo systemctl start service     # Start service
sudo systemctl stop service      # Stop service
sudo systemctl restart service   # Restart service
sudo systemctl reload service    # Reload configuration
sudo systemctl enable service    # Enable auto-start
sudo systemctl disable service   # Disable auto-start
sudo systemctl status service    # Check service status

# Service Information
systemctl list-units --type=service  # List all services
systemctl list-unit-files            # List service files
systemctl is-active service          # Check if active
systemctl is-enabled service         # Check if enabled

# Journal (Logs)
sudo journalctl -u service           # Service logs
sudo journalctl -f                   # Follow logs
sudo journalctl --since "1 hour ago" # Recent logs
sudo journalctl -p err               # Error logs only
sudo journalctl -xe                  # Detailed logs

Network Tools
bash

# Connectivity Testing
ping hostname               # Test connectivity
ping -c 4 hostname          # Send 4 packets
traceroute hostname         # Trace network path
mtr hostname                # Advanced traceroute

# DNS Tools
nslookup domain             # DNS lookup
dig domain                  # Detailed DNS query
host domain                 # Simple DNS lookup
cat /etc/resolv.conf        # DNS configuration

# Port and Connection Testing
netcat -zv host port        # Test port connectivity
telnet host port            # Test TCP connection
curl http://host            # HTTP client
wget http://host/file       # Download file

# Network Configuration
ip addr add 192.168.1.10/24 dev eth0  # Add IP address
ip route add default via 192.168.1.1  # Add default route

Compression and Archives
bash

# tar - Tape Archive
tar -czf archive.tar.gz folder/    # Create compressed archive
tar -xzf archive.tar.gz            # Extract compressed archive
tar -tf archive.tar.gz             # List contents
tar -czf backup.tar.gz --exclude="*.tmp" folder/  # Exclude files

# gzip
gzip file.txt                     # Compress file (creates file.txt.gz)
gunzip file.txt.gz                # Decompress
gzip -d file.txt.gz               # Alternative decompress

# zip/unzip
zip archive.zip file1 file2       # Create zip archive
unzip archive.zip                 # Extract zip
unzip -l archive.zip              # List contents

Search and Find
bash

# find - File search
find /path -name "*.txt"          # Find files by name
find /path -type f                # Find only files
find /path -type d                # Find only directories
find /path -mtime -7              # Modified in last 7 days
find /path -size +100M            # Larger than 100MB
find /path -user username         # Owned by user
find /path -exec chmod 644 {} \;  # Execute command on found files

# locate - Fast file search
sudo updatedb                    # Update database (run first)
locate filename                  # Find file by name
locate -i filename               # Case insensitive
locate -c filename               # Count matches

# which/whereis
which command                    # Show command path
whereis command                  # Show command, source, man page

Shell and Environment
bash

# Environment Variables
echo $PATH                       # View PATH variable
export VAR=value                 # Set environment variable
unset VAR                        # Remove variable
env                              # Show all environment variables
printenv                         # Alternative to env

# History
history                          # Command history
!!                               # Last command
!10                              # Execute command #10 from history
Ctrl+R                           # Search history
history -c                       # Clear history

# Aliases
alias ll='ls -la'                # Create alias
unalias ll                       # Remove alias
alias                            # List all aliases

# Shell Configuration
source ~/.bashrc                 # Reload bash configuration
echo $SHELL                      # Show current shell
chsh -s /bin/bash                # Change default shell

Performance Monitoring
bash

# System Load
uptime                           # Load averages
w                                # Who and what they're doing
top                              # Real-time system monitor
htop                             # Enhanced top

# Memory
free -h                          # Memory usage
vmstat 1 5                       # Virtual memory stats
sar -r 1 3                       # Memory activity

# CPU
mpstat 1 3                       # CPU statistics
sar -u 1 3                       # CPU utilization
pidstat 1                        # Process statistics

# Disk I/O
iostat 1 3                       # Disk I/O statistics
iotop                            # Top for I/O
df -i                            # Inode usage

# Network
iftop                            # Network bandwidth
nethogs                          # Bandwidth per process
iptraf-ng                        # Network monitoring

SSH and Remote Access
bash

# Basic SSH
ssh user@host                    # Connect to remote host
ssh -p 2222 user@host           # Specify port
ssh -i key.pem user@host        # Use specific key

# SSH Key Management
ssh-keygen -t rsa -b 4096       # Generate RSA key
ssh-copy-id user@host           # Copy key to remote
ssh-agent bash                   # Start SSH agent
ssh-add ~/.ssh/id_rsa           # Add key to agent

# SSH Configuration (~/.ssh/config)
# Host myserver
#     HostName server.com
#     User username
#     Port 22
#     IdentityFile ~/.ssh/id_rsa

# SCP - Secure Copy
scp file.txt user@host:/path     # Copy to remote
scp user@host:/path/file.txt .   # Copy from remote
scp -r folder/ user@host:/path   # Copy directory

# SSH Tunnels
ssh -L 8080:localhost:80 user@host  # Local port forward
ssh -R 8080:localhost:80 user@host  # Remote port forward
ssh -D 1080 user@host              # Dynamic SOCKS proxy

Cron Jobs
bash

crontab -e                        # Edit crontab
crontab -l                        # List cron jobs
crontab -r                        # Remove all cron jobs

# Cron Format: * * * * * command
# ┌────────── minute (0-59)
# │ ┌──────── hour (0-23)
# │ │ ┌────── day of month (1-31)
# │ │ │ ┌──── month (1-12)
# │ │ │ │ ┌── day of week (0-6, Sunday=0)
# * * * * *

# Examples:
0 2 * * * /path/backup.sh        # Daily at 2 AM
*/15 * * * * /path/check.sh      # Every 15 minutes
0 0 1 * * /path/report.sh        # Monthly on 1st
0 9-17 * * 1-5 /path/monitor.sh  # Weekdays 9 AM-5 PM

System Logs
bash

# Common Log Locations
/var/log/syslog                  # System logs
/var/log/auth.log               # Authentication logs
/var/log/kern.log               # Kernel logs
/var/log/dmesg                  # Boot messages
/var/log/nginx/                 # Nginx logs
/var/log/apache2/               # Apache logs

# Log Viewing Commands
tail -f /var/log/syslog         # Follow system log
grep "error" /var/log/syslog    # Search for errors
journalctl -f                   # Follow systemd journal
dmesg | tail -20                # Recent kernel messages
last                            # Last logins

Firewall (UFW/iptables)
bash

# UFW (Simplified)
sudo ufw enable                 # Enable firewall
sudo ufw disable                # Disable firewall
sudo ufw status                 # Check status
sudo ufw allow ssh              # Allow SSH
sudo ufw allow 80/tcp           # Allow HTTP
sudo ufw allow from 192.168.1.0/24  # Allow from subnet
sudo ufw delete allow ssh       # Delete rule

# iptables (Advanced)
sudo iptables -L                # List rules
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT  # Allow SSH
sudo iptables -A INPUT -j DROP  # Default deny
sudo iptables-save > rules.v4   # Save rules
sudo iptables-restore < rules.v4 # Restore rules

Shortcuts and Tips
bash

# Terminal Shortcuts
Ctrl+A                         # Move to beginning of line
Ctrl+E                         # Move to end of line
Ctrl+U                         # Cut to beginning of line
Ctrl+K                         # Cut to end of line
Ctrl+Y                         # Paste cut text
Ctrl+W                         # Cut previous word
Ctrl+L                         # Clear screen
Ctrl+D                         # Exit shell/EOF

# Useful One-liners
# Count files in directory: ls -1 | wc -l
# Find largest files: find . -type f -exec du -h {} + | sort -rh | head -10
# Search and replace in multiple files: find . -name "*.txt" -exec sed -i 's/old/new/g' {} +
# Monitor directory for changes: watch -n 1 'ls -la'
# Download entire website: wget --mirror --convert-links website.com

# Disk Usage Analysis
ncdu                           # Interactive disk usage analyzer
du -ah . | sort -rh | head -20 # Top 20 largest files
df -h --output=source,size,used,avail,pcent # Disk usage table

🎯 Common Command Combinations
System Information
bash

# Full system info
uname -a && cat /etc/os-release && lscpu && free -h && df -h

# Process tree with resource usage
ps auxf | less

# Top 10 memory consuming processes
ps aux --sort=-%mem | head -11

# Top 10 CPU consuming processes
ps aux --sort=-%cpu | head -11

Network Diagnostics
bash

# Complete network check
ip addr show && ip route show && ping -c 2 8.8.8.8 && nslookup google.com

# Check open ports and services
ss -tulpn | sort -k5

# Monitor network traffic
sudo tcpdump -i any -n -c 10

File Operations
bash

# Find and compress old logs
find /var/log -name "*.log" -mtime +30 -exec gzip {} \;

# Backup with timestamp
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz /path/to/backup

# Find and delete empty files
find . -type f -empty -delete

🔧 Troubleshooting Commands
When system is slow:
bash

top                          # Check CPU/Memory usage
iostat -x 1 3                # Disk I/O
sar -n DEV 1 3               # Network traffic
dmesg | tail -20             # Kernel errors

When disk is full:
bash

df -h                        # Check disk usage
du -sh /*                    # Check each directory
du -ah . | sort -rh | head -20  # Largest files
lsof +L1                     # Deleted files still open

When network is down:
bash

ip addr show                 # Check IP addresses
ping 127.0.0.1              # Localhost test
ping gateway                # Gateway test
traceroute google.com       # Path to internet
nslookup google.com         # DNS resolution

📝 Best Practices
1. Safety First
bash

rm -i file                  # Confirm before deleting
cp -i source dest           # Confirm before overwriting
mv -i source dest           # Confirm before moving
alias rm='rm -i'            # Make rm interactive by default

2. Useful Aliases
bash

# Add to ~/.bashrc or ~/.bash_aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias h='history'
alias hg='history | grep'
alias df='df -h'
alias du='du -h'
alias mkdir='mkdir -pv'

3. Script Safety
bash

#!/bin/bash
set -e      # Exit on error
set -u      # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

🎓 Quick Reference by Category
File Operations:

    Create: touch, mkdir

    View: cat, less, head, tail

    Edit: nano, vim, sed

    Copy/Move: cp, mv

    Delete: rm, rmdir

System Info:

    System: uname, hostname, uptime

    Hardware: lscpu, free, df, lsblk

    Users: whoami, id, w, last

Process Management:

    View: ps, top, htop

    Control: kill, jobs, fg, bg

    Priority: nice, renice

Networking:

    Info: ip, ifconfig, netstat, ss

    Testing: ping, traceroute, curl, wget

    DNS: nslookup, dig, host

Permissions:

    Change: chmod, chown, chgrp

    Default: umask

    Special: setuid, setgid, sticky bit

Package Management:

    Debian: apt, dpkg

    RHEL: yum, dnf, rpm

    Arch: pacman