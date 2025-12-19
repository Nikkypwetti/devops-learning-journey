#!/bin/bash
# Week 1: Linux Command Line Practice Script
# Created: $(date)
# Purpose: Practice all Week 1 concepts

echo "=========================================="
echo "Week 1: Linux Command Line Fundamentals"
echo "=========================================="

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Function to test command
test_command() {
    echo -e "${YELLOW}Testing: $1${NC}"
    eval $2
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Success${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
    fi
    echo ""
}

# Create practice directory
PRACTICE_DIR="$HOME/linux-week1-practice"
mkdir -p $PRACTICE_DIR
cd $PRACTICE_DIR

print_header "Day 1: Filesystem Navigation"
test_command "Create directory structure" "mkdir -p project/{src,docs,tests,logs}"
test_command "Navigate directories" "cd project && pwd"
test_command "List contents" "ls -la"

print_header "Day 2: File Management"
test_command "Create test files" "touch file1.txt file2.txt file3.txt"
test_command "Copy files" "cp file1.txt file1_backup.txt"
test_command "Move files" "mv file2.txt docs/"
test_command "Remove files" "rm file3.txt"

print_header "Day 3: Text Processing"
# Create sample text file
cat > sample.txt << EOF
Server1: Running, CPU: 45%, Memory: 78%
Server2: Stopped, CPU: 0%, Memory: 12%
Server3: Running, CPU: 89%, Memory: 92%
Server4: Running, CPU: 23%, Memory: 45%
EOF

test_command "Grep for running servers" "grep 'Running' sample.txt"
test_command "Sed replace text" "sed 's/Running/Active/g' sample.txt"
test_command "Awk extract columns" "awk -F': ' '{print \$1}' sample.txt"

print_header "Day 4: Permissions"
test_command "Create script file" "echo 'echo Hello World' > script.sh"
test_command "Change permissions" "chmod 755 script.sh"
test_command "Test execution" "./script.sh"
test_command "Change ownership (simulated)" "ls -l script.sh"

print_header "Day 5: Process Management"
test_command "List processes" "ps aux | grep -v grep | head -5"
test_command "Show system load" "uptime"
test_command "Create background job" "sleep 10 &"

print_header "Day 6: Shell Scripting"
cat > system_info.sh << 'EOF'
#!/bin/bash
# System Information Script

echo "=== System Information ==="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo "Memory Usage:"
free -h
echo "Disk Usage:"
df -h | grep -v tmpfs
EOF

chmod +x system_info.sh
test_command "Run system info script" "./system_info.sh"

print_header "Cleanup"
echo "Cleaning up practice files..."
cd ~
rm -rf $PRACTICE_DIR
echo -e "${GREEN}Practice session completed!${NC}"

# Create cheatsheet
cat > ~/linux-week1-cheatsheet.md << 'EOF'
# Linux Week 1 Cheatsheet

## Navigation
- `pwd` - Print working directory
- `ls` - List contents
- `cd` - Change directory
- `mkdir` - Create directory

## File Operations
- `cp source dest` - Copy file
- `mv source dest` - Move/rename file
- `rm file` - Remove file
- `touch file` - Create empty file

## Text Processing
- `grep pattern file` - Search for pattern
- `sed 's/old/new/g' file` - Replace text
- `awk '{print $1}' file` - Print first column

## Permissions
- `chmod 755 file` - rwxr-xr-x
- `chmod 644 file` - rw-r--r--
- `chown user:group file` - Change ownership

## Process Management
- `ps aux` - List all processes
- `top` - Interactive process viewer
- `kill PID` - Kill process by ID
- `jobs` - List background jobs

## Scripting
- `#!/bin/bash` - Shebang line
- `$variable` - Use variable
- `if [ condition ]; then` - If statement
- `for i in {1..10}; do` - For loop
EOF

echo -e "\n${GREEN}Cheatsheet saved to: ~/linux-week1-cheatsheet.md${NC}"