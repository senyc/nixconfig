{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = {
    keepassxc.enable = lib.mkEnableOption "Enable keepassxc, and mount related drives";
  };
  config = lib.mkIf config.keepassxc.enable {
    environment.systemPackages = with pkgs; [
      keepassxc
    ];

    systemd.user.tmpfiles.rules = [
      "d /pass - senyc - - -"
    ];
    fileSystems."/pass" = {
      device = "/dev/disk/by-label/pass";
      fsType = "ext4";
      noCheck = true;
      options = ["nofail"];
    };
  };
}
