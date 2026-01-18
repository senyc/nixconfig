#!/usr/bin/env bash

# Replace /dev/nvme0n1 with drive you want to install to
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake .#boot --disk main /dev/nvme0n1

