{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    modules.system.wayland.enable = lib.mkEnableOption "Enable general wayland configuration";
  };

  config = lib.mkIf config.modules.system.wayland.enable {
    # Allows for screen sharing to work
    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = [
            "hyprland"
          ];
        };
      };
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    };

    # This is a requirement for various gtk related services
    programs.dconf.enable = true;

    environment.sessionVariables = {
      QT_SCALE_FACTOR = 1;
      ELM_SCALE = 1;
      GDK_SCALE = 1;
      XCURSOR_SIZE = 16;
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      TERM ="xterm-256color";
    };
  };
}
