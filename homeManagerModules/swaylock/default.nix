{
  pkgs,
  config,
  lib,
  ...
} : {

  options = {
    swaylock.enable = lib.mkEnableOption "Enable swaylock";
  };
  config = lib.mkIf config.swaylock.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        show-failed-attempts = true;

      };
    };
  };
}
