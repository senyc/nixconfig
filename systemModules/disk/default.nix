{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    modules.system.disk.enable = mkEnableOption "Enable default primary disk partitions";
  };

  config = mkIf config.modules.system.disk.enable {
    environment.systemPackages = with pkgs; [
      tpm2-tss
    ];

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
                name = "cryptroot";
                settings.allowDiscards = true;
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  extraArgs = ["-Lcryptroot"];
                };
              };
            };
          };
        };
      };
    };
  };
}
