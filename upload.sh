#!/usr/bin/env bash

set -e

SD_CARD_PATH=$1
SD_CARD_ALL_PARTITIONS="${SD_CARD_PATH}\*"
SD_CARD_PARTITION="${SD_CARD_PATH}1"

sudo mount $SD_CARD_PARTITION /mnt/rpi_boot
sudo cp build/kernel_2712.img /mnt/rpi_boot
sudo cp artifacts/config.txt /mnt/rpi_boot
sync
sudo umount $SD_CARD_PARTITION

echo "UPLOADED"