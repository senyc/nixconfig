{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    modules.system.cosmic.enable = lib.mkEnableOption "Enable cosmic de";
  };

  config = lib.mkIf config.modules.system.cosmic.enable {
    # Allows for screen sharing to work
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
      grim
    ];

    programs.firefox.preferences = {
      # disable libadwaita theming for Firefox
      "widget.gtk.libadwaita-colors.enabled" = false;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      COSMIC_DATA_CONTROL_ENABLED = 1;
    };
  };
}
