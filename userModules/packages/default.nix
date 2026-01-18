{
  pkgs,
  lib,
  config,
  outputs,
  ...
}:
with lib; {
  options = {
    modules.user.packages.enable = mkEnableOption "Enable default home packages";
  };

  config = mkIf config.modules.user.packages.enable {
    # Allow certain unfree user-level packages
    allowedUnfree = [
      "slack"
      "spotify"
      "obsidian"
      "_1password-gui"
      "1password"
    ];

    nixpkgs.overlays = [outputs.overlays.addPackages];

    home.packages = with pkgs; [
      vlc
      obsidian
      aspell
      vlc
      aspellDicts.en
      _1password-gui
      chromium
      yubikey-manager
      pavucontrol
      senyc-nvimconfig
      slack
      spotify
    ];
  };
}
