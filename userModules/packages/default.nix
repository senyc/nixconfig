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
      "discord"
    ];

    nixpkgs.overlays = [outputs.overlays.addPackages];

    home.packages = with pkgs; [
      vlc
      obsidian
      aspell
      discord
      vlc
      aspellDicts.en
      chromium
      yubikey-manager
      pavucontrol
      qalculate-qt
      senyc-nvimconfig
      slack
      spotify
    ];
  };
}
