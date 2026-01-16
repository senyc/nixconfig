# sudo systemd-cryptenroll /dev/nvme0n1 \
# --tpm2-device=auto \
# --tpm2-pcrs=0+2+4+7 \
# /dev/disk/by-uuid/{uuid}
 systemd-cryptenroll /dev/nvme0n1 --recovery-key
 systemd-cryptenroll /dev/nvme0n1 --wipe-slot=empty --tpm2-device=auto --tpm2-pcrs=7+15:sha256=0000000000000000000000000000000000000000000000000000000000000000
# I just did lsblk for this
