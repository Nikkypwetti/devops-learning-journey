# Mounting Amazon EFS to EC2 Instances

## Prerequisites

- EFS file system created in your VPC
- Mount targets configured in each AZ
- Security group allowing NFS (port 2049) from EC2 instances
- EC2 instances in the same VPC as EFS

## Installation Steps

### 1. Install EFS Utilities

```bash
# Amazon Linux 2 / Amazon Linux 2023
sudo yum install -y amazon-efs-utils

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y amazon-efs-utils

# CentOS/RHEL 7+
sudo yum install -y nfs-utils

2. Create Mount Directory
bash

sudo mkdir /mnt/efs
sudo chown ec2-user:ec2-user /mnt/efs

3. Mount EFS File System
bash

# Using EFS mount helper (recommended)
sudo mount -t efs -o tls fs-12345678:/ /mnt/efs

# Manual NFS mount (if helper not available)
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-12345678.efs.us-east-1.amazonaws.com:/ /mnt/efs

4. Auto-mount on Boot (fstab)
bash

# Add to /etc/fstab
fs-12345678:/ /mnt/efs efs defaults,_netdev 0 0

# Or using mount helper
fs-12345678:/ /mnt/efs efs defaults,_netdev,tls 0 0

# Test the fstab entry
sudo mount -a

5. Verify Mount
bash

df -hT | grep efs
ls -la /mnt/efs

Mount Options Explained

    tls: Use TLS encryption for data in transit

    _netdev: Wait for network to be available

    nfsvers=4.1: Use NFS version 4.1

    hard: Persistent retries on timeout

    rsize/wsize: Read/write block sizes (1MB)

Troubleshooting

    Permission denied: Check security group rules

    Mount hangs: Verify network connectivity

    No route to host: Check VPC routing tables

    Access denied: Verify NFS port 2049 is open

Best Practices

    Use mount helper for automatic retries and TLS

    Mount in multiple AZs for high availability

    Monitor file system performance with CloudWatch

    Use encryption at rest and in transit