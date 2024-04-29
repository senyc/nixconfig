{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    wayland.enable = lib.mkEnableOptions "Enable general wayland configuration";
  };

  config = lib.mkIf config.wayland.enable {
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
  };

  # This is a requirement for various gtk related services
  programs.dconf.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
}
