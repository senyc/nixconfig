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
      brave
      slack
      neofetch
      logseq
      doctl
      kubectl
      pamixer
      playerctl
      aspell
      wl-clipboard
      keepassxc
      obs-studio
      pavucontrol
    ];
  };
}