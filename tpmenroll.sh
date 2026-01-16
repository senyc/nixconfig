# sudo systemd-cryptenroll /dev/nvme0n1 \
# --tpm2-device=auto \
# --tpm2-pcrs=0+2+4+7 \
# /dev/disk/by-uuid/{uuid}

#possibly use the nvme0n1p2 partition
 systemd-cryptenroll /dev/nvme0n1 --recovery-key
 systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0 /dev/nvme0n1
# I just did lsblk for this
