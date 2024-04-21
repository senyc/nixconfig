{ 
  config, 
  pkgs, 
  lib,
  ... 
}: {
  imports = [ 
    ./tmux
    ./alacritty
    ./zsh
    ./git
    ./wofi
    ./gbar
    ./hypr/land
    ./hypr/lock
    ./hypr/idle
    ./nvim
    ./spicetify
  ]; 

  home.username = "senyc";
 
  # Allow certain unfree user-level packages
  nixpkgs.config.allowUnfreePredicate = pkg: lib.elem (lib.getName pkg) [ 
    "spotify" 
    "slack"
  ];

  alacritty.enable = true;
  tmux.enable = true;
  zsh.enable = true;
  git.enable = true;
  wofi.enable = true;
  hyprlock.enable = true;
  hypridle.enable = true;
  hyprland.enable = true;
  gbar.enable = true;
  nvim.enable = true;
  spicetify.enable = true;

  home.homeDirectory = "/home/senyc";

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = with pkgs; [
    brave
    slack
    neofetch
    logseq
    pamixer
    playerctl
    aspell
    wl-clipboard
    pavucontrol
    (writeShellScriptBin "rebuild" ''
      sudo nixos-rebuild switch --flake $HOME/nixconfig#default
    '')
    (writeShellScriptBin "screenshot" ''
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp -w 0)" - | wl-copy
     '')
    (writeShellScriptBin "rmdockercontainers" ''
      for i in $(${docker}/bin/docker ps --all | awk '{print $1}' | tail -n +2); do
        ${docker}/bin/docker rm $i
      done
     '')
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11"; # Probably don't change this
}
