#!/bin/bash
set -e

# Change disk30 to your actual USB identifier (check via 'diskutil list')
USB_DRIVE="/dev/disk30"

echo "========================================"
echo "  AI-OS Desktop - Physical Media Boot"
echo "========================================"

echo "[*] Requesting root privileges to read physical silicon..."
sudo qemu-system-aarch64 \
    -M virt,gic-version=2 \
    -cpu cortex-a53 \
    -m 1024M \
    -display cocoa \
    -drive file=${USB_DRIVE},if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -device virtio-gpu-device \
    -device virtio-keyboard-device \
    -kernel build/os_desktop.elf \
    -serial tcp:127.0.0.1:4444,server,nowait
