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
