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

    nixpkgs.overlays = [outputs.overlays.addPackages];

    home.packages = with pkgs; [
      arduino
      aspell
      doctl
      senyc-nvimconfig
      keepassxc
      kubectl
      kubernetes-helm
      logseq
      obs-studio
      pamixer
      pavucontrol
      playerctl
      slack
      spotify
      stern
      wl-clipboard
    ];
  };
}
