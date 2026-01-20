#!/bin/bash
set -e

echo "Waiting for any background apt processes to finish..."
# This is a Pro trick to wait for Ubuntu's background updates to stop
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "Waiting for other software managers to finish..."
    sleep 5
done

echo "Cleaning up..."
# Skip autoremove for now to avoid the initramfs error
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -rf /var/tmp/*

# Remove SSH host keys
rm -f /etc/ssh/ssh_host_*

# Zero out the free space (This makes the file small)
echo "Zeroing out free space (this may take a moment)..."
#dd if=/dev/zero of=/EMPTY bs=1M conv=fdatasync || true
rm -f /EMPTY

sync
echo "Cleanup complete!"