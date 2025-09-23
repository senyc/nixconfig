{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    modules.user.flameshot.enable = lib.mkEnableOption "Enable flameshot";
  };
  config = lib.mkIf config.modules.user.flameshot.enable {
    services.flameshot = with pkgs; {
      enable = true;
      package = flameshot.override {enableWlrSupport = true;};
      settings = {
        General = {
          disabledGrimWarning = true;
          useGrimAdapter = true;
          showDesktopNotification = false;
          showStartupLaunchMessage = false;
        };
      };
    };
  };
}
