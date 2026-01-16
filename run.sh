sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake .#basic --disk main /dev/nvme0n1

