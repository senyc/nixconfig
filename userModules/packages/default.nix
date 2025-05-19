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
    ];

    nixpkgs.overlays = [outputs.overlays.addPackages];

    home.packages = with pkgs; [
      aspell
      aspellDicts.en
      keepassxc
      obs-studio
      chromium
      spotify
      pavucontrol
      senyc-nvimconfig
      slack
      tor-browser
    ];
  };
}
