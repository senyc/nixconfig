{
  pkgs,
  lib,
  config,
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
        "zoom"
        "upwork"
      ];
    home.packages = with pkgs; [
      arduino
      upwork
      zoom-us
      aspell
      doctl
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
