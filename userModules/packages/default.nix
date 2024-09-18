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
      "spotify"
      "slack"
    ];

    nixpkgs.overlays = [outputs.overlays.addPackages];

    home.packages = with pkgs; [
      aspell
      aspellDicts.en
      keepassxc
      logseq
      obs-studio
      pavucontrol
      senyc-nvimconfig
      spotify
      slack
    ];
  };
}
