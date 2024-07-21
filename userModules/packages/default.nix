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
    nixpkgs.config.allowUnfreePredicate = pkg:
      lib.elem (lib.getName pkg) [
        "spotify"
        "slack"
      ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-27.3.11"
    ];

    nixpkgs.overlays = [outputs.overlays.addPackages];

    home.packages = with pkgs; [
      aspell
      doctl
      keepassxc
      kubectl
      kubernetes-helm
      terraform
      logseq
      obs-studio
      pamixer
      pavucontrol
      playerctl
      senyc-nvimconfig
      slack
      spotify
      stern
    ];
  };
}
