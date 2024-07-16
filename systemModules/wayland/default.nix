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

    services.pipewire = {
      enable = true;
      # For screen sharing
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # This is a requirement for various gtk related services
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];

    environment.sessionVariables = {
      QT_SCALE_FACTOR = 1;
      ELM_SCALE = 1;
      GDK_SCALE = 1;
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}
