#!/bin/bash
# Week 2: Advanced Linux Administration Practice
# Note: Some commands require sudo/simulated environment

echo "=========================================="
echo "Week 2: Advanced Linux Administration"
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

# Create practice environment
PRACTICE_DIR="$HOME/linux-week2-practice"
mkdir -p $PRACTICE_DIR/{users,logs,backups,services}
cd $PRACTICE_DIR

print_header "Day 8: Package Management Simulation"
echo "Simulating package management (dry runs only)"
echo "On Ubuntu/Debian: sudo apt update && sudo apt install nginx"
echo "On RHEL/CentOS: sudo yum install nginx"
echo "Checking if packages are available..."
which nginx 2>/dev/null && echo -e "${GREEN}✓ nginx is installed${NC}" || echo -e "${YELLOW}⚠ nginx not installed${NC}"

print_header "Day 9: User & Group Management"
echo "Creating test users and groups (simulated)"
cat > users.txt << EOF
# User list format: username:uid:gid:comment
alice:1001:1001:Alice Developer
bob:1002:1002:Bob Tester
charlie:1003:1003:Charlie Admin
EOF

echo "Sample commands to run (as root):"
echo "  useradd -m -s /bin/bash alice"
echo "  passwd alice"
echo "  usermod -aG sudo alice"
echo "  groupadd developers"
echo "  usermod -aG developers alice"

print_header "Day 10: Disk Management Simulation"
echo "Simulating disk operations"
cat > disk-info.txt << EOF
# Disk layout simulation
/dev/sda1: /boot     (500M)
/dev/sda2: /         (20G)
/dev/sda3: /home     (30G)
/dev/sdb1: /data     (50G)
EOF

echo "Sample commands (requires sudo):"
echo "  fdisk -l"
echo "  df -h"
echo "  du -sh /home/*"
echo "  mount /dev/sdb1 /mnt/data"

print_header "Day 11: Systemd Service Management"
# Create a simple systemd service file
cat > services/test-service.service << 'EOF'
[Unit]
Description=Test Service
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c "while true; do echo 'Service running' >> /tmp/test-service.log; sleep 10; done"
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo "Created test service file: services/test-service.service"
echo "Commands to manage (as root):"
echo "  sudo systemctl daemon-reload"
echo "  sudo systemctl start test-service"
echo "  sudo systemctl enable test-service"
echo "  journalctl -u test-service -f"

print_header "Day 12: Log Management"
# Create sample log files
for i in {1..5}; do
    echo "$(date): Log entry $i - INFO: System normal" >> logs/app.log
    echo "$(date): Log entry $i - ERROR: Something went wrong" >> logs/error.log
done

echo "Created sample log files in logs/"
echo "Viewing logs:"
echo "Tail last 5 lines:"
tail -5 logs/app.log
echo ""
echo "Search for errors:"
grep -i error logs/error.log

print_header "Day 13: Cron Jobs"
# Create a backup script
cat > backups/backup-script.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backups"
SOURCE_DIR="$HOME/documents"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "[$TIMESTAMP] Starting backup..." >> /var/log/backup.log
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" "$SOURCE_DIR" 2>> /var/log/backup.log
echo "[$TIMESTAMP] Backup completed" >> /var/log/backup.log
EOF

chmod +x backups/backup-script.sh

echo "Created backup script: backups/backup-script.sh"
echo "Cron entry examples:"
echo "  0 2 * * * /path/to/backup-script.sh  # Daily at 2 AM"
echo "  */30 * * * * /path/to/monitor.sh      # Every 30 minutes"
echo "  0 0 1 * * /path/to/monthly-report.sh  # Monthly on 1st"

print_header "Day 14: LAMP Stack Setup Commands"
cat > setup-lamp.sh << 'EOF'
#!/bin/bash
# LAMP Stack Setup Script (Ubuntu/Debian)

# Update system
sudo apt update
sudo apt upgrade -y

# Install Apache
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

# Install MySQL
sudo apt install mysql-server -y
sudo mysql_secure_installation

# Install PHP
sudo apt install php libapache2-mod-php php-mysql -y

# Configure Apache for PHP
sudo systemctl restart apache2

# Test PHP
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

echo "LAMP stack installed!"
echo "Access: http://server-ip/info.php"
EOF

echo "LAMP setup script created: setup-lamp.sh"
echo "To install: chmod +x setup-lamp.sh && sudo ./setup-lamp.sh"

print_header "Cleanup and Summary"
echo "Practice files created in: $PRACTICE_DIR"
echo -e "${YELLOW}Note: These are simulation files. Real commands require appropriate privileges.${NC}"

# Create Week 2 cheatsheet
cat > ~/linux-week2-cheatsheet.md << 'EOF'
# Linux Week 2 Cheatsheet: System Administration

## Package Management
### Debian/Ubuntu
- `apt update` - Update package lists
- `apt upgrade` - Upgrade packages
- `apt install package` - Install package
- `apt remove package` - Remove package
- `apt search pattern` - Search packages

### RHEL/CentOS
- `yum install package` - Install package
- `yum update` - Update packages
- `yum remove package` - Remove package
- `yum search pattern` - Search packages

## User Management
- `useradd username` - Create user
- `usermod -aG group username` - Add user to group
- `userdel username` - Delete user
- `passwd username` - Change password
- `id username` - Show user info

## Disk Management
- `fdisk -l` - List partitions
- `mkfs.ext4 /dev/sda1` - Create filesystem
- `mount /dev/sda1 /mnt` - Mount partition
- `umount /mnt` - Unmount
- `df -h` - Show disk usage
- `du -sh directory` - Show directory size

## Systemd Services
- `systemctl start service` - Start service
- `systemctl stop service` - Stop service
- `systemctl restart service` - Restart service
- `systemctl enable service` - Enable auto-start
- `systemctl status service` - Check status
- `journalctl -u service -f` - Follow logs

## Log Management
- `/var/log/syslog` - System logs
- `journalctl -f` - Follow all logs
- `journalctl --since "1 hour ago"` - Recent logs
- `journalctl -p err` - Error logs only

## Cron Jobs
- `crontab -e` - Edit cron jobs
- `crontab -l` - List cron jobs
- `crontab -r` - Remove all jobs
- Format: `* * * * * command`
  - Minute Hour Day Month Weekday

## Common Directories
- `/etc/` - Configuration files
- `/var/log/` - Log files
- `/home/` - User directories
- `/tmp/` - Temporary files
- `/usr/bin/` - User binaries
- `/usr/local/bin/` - Local binaries
EOF

echo -e "\n${GREEN}Cheatsheet saved to: ~/linux-week2-cheatsheet.md${NC}"
echo -e "\n${GREEN}Week 2 practice completed!${NC}"