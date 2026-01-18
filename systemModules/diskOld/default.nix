{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.diskOld.enable = mkEnableOption "Enable default primary disk partitions";
  };

  # to run on install (not tested)
  config = mkIf config.modules.system.diskOld.enable {
    disko.devices = {
      disk.main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
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
}
