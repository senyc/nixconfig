{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    homePackages.enable = mkEnableOption "Enable default home packages";
  };

  config = mkIf config.homePackages.enable {
    # Allow certain unfree user-level packages
    nixpkgs.config.allowUnfreePredicate = pkg:
      lib.elem (lib.getName pkg) [
        "spotify"
        "slack"
      ];
    home.packages = with pkgs; [
      arduino
      aspell
      brave
      doctl
      keepassxc
      kubectl
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
