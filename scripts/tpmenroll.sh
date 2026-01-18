#!/usr/bin/env bash

# May need to update the drive/partition to unlock via tpm
sudo systemd-cryptenroll  --recovery-key /dev/nvme0n1p2
sudo systemd-cryptenroll --tpm2-device=auto --wipe-slot=tpm2 --tpm2-pcrs=0+2+4 /dev/nvme0n1p2
