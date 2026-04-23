#!/bin/bash
set -e

IMG_NAME="ai-os-live.img"

echo "[*] Cleaning up old images..."
rm -f $IMG_NAME temp.dmg temp.cdr

echo "[*] Generating 64MB FAT32 disk image..."
hdiutil create -size 64m -fs "MS-DOS FAT32" -volname "AIOS" -layout MBRSPUD temp.dmg

echo "[*] Mounting image to inject test payload..."
DEVICE_INFO=$(hdiutil attach temp.dmg)
MOUNT_POINT=$(echo "$DEVICE_INFO" | grep -i "AIOS" | awk -F'\t' '{print $3}')
DEVICE_NODE=$(echo "$DEVICE_INFO" | head -n 1 | awk '{print $1}')

if [ -n "$MOUNT_POINT" ]; then
    echo "Sovereign FAT32 Driver Active. Test file read successfully." > "$MOUNT_POINT/TEST.TXT"
    echo "[*] TEST.TXT injected."
    hdiutil detach "$DEVICE_NODE" -force
else
    echo "[!] Warning: Could not mount volume."
fi

echo "[*] Converting to RAW format for QEMU..."
hdiutil convert temp.dmg -format UDTO -o temp.cdr
mv temp.cdr $IMG_NAME
rm temp.dmg

echo "[*] Build complete: $IMG_NAME ready for VirtIO."