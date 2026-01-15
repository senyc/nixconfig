{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.disk.enable = mkEnableOption "Enable default primary disk partitions";
  };

  # to run on install (not tested)
  # sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake .#<flake-attr> --disk main /dev/nvme0n1
  config = mkIf config.modules.system.disk.enable {
    disko.devices = {
      disk.main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                format = "ext4";
                mountpoint = "/";
                # This new was in the other content before
                extraArgs = ["-Lcryptroot"];
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}
