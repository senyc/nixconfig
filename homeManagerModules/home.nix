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
    ./zoxide
    ./hypr/land
    ./hypr/lock
    ./hypr/idle
    ./hypr/paper
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
  hyprpaper.enable = true;
  gbar.enable = true;
  nvim.enable = true;
  zoxide.enable = true;
  spicetify.enable = true;

  home.homeDirectory = "/home/senyc";

  # This is a requirement for mouse cursor configuration
  gtk.enable = true;

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
    doctl
    kubectl
    pamixer
    playerctl
    aspell
    wl-clipboard
    keepassxc
    pavucontrol
    (writeShellScriptBin "rebuild" ''
      set -e
      pushd ~/nixconfig/

      # if git diff --quiet; then
      #     echo "No changes detected, exiting."
      #     popd
      #     exit 0
      # fi

      # Show changes 
      git diff -U0 

      echo "NixOS Rebuilding..."

      sudo nixos-rebuild switch --flake ~/nixconfig#default &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
      echo "NixOS Rebuilt, commiting changes"

      # Get current generation metadata
      current=$(nixos-rebuild list-generations --flake ~/nixconfig#default | grep current | awk '{print $1, $3}')

      # Add the generation number to the commit message and add all changes to the commit
      git commit -am "feat: update nix generation to $current"
      popd
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
