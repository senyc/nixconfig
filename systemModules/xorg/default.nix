{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    modules.system.xorg.enable = lib.mkEnableOption "Enables xorg-related settings";
  };
  config = lib.mkIf config.modules.system.xorg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = false;
      };
      desktopManager.gnome.enable = true;
    };

    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      gnomeExtensions.appindicator
      xclip
    ];

    hardware.pulseaudio.enable = false;

    services.udev.packages = with pkgs; [gnome-settings-daemon];
  };
}
