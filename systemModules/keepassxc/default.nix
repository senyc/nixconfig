{
  config,
  lib,
  ...
}: {
  options = {
    modules.system.keepassxc.enable = lib.mkEnableOption "Enable keepassxc mounted related drives";
  };
  config = lib.mkIf config.modules.system.keepassxc.enable {
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
