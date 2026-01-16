#!/usr/bin/env bash

# May need to update the drive to unlock via tpm
sudo systemd-cryptenroll  --recovery-key /dev/nvme0n1p2
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0 /dev/nvme0n1p2
