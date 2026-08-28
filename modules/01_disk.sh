#!/bin/bash
set -e

source ./select_menu.sh
mapfile -t disks < <(lsblk -d -n -o NAME,SIZE,MODEL | grep -E "sd|nvme")
if [ ${#disks[0]} -eq 0 ]; then
	echo "not found"
	exit 1
fi 
select_menu "dsdsds" "${disks[@]}"
TARGET_DISK=$(echo "$REPLY" | awk '{print $1}')
echo "$REPLY"
