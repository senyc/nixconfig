{ 
  config, 
  pkgs, 
  inputs,
  ... 
}: {
  imports = [ 
    inputs.gBar.homeManagerModules.x86_64-linux.default 
    ./homeManagerModules/tmux
    ./homeManagerModules/alacritty
    ./homeManagerModules/zsh
    ./homeManagerModules/git
    ./homeManagerModules/wofi
    ./homeManagerModules/hyprland
    ./homeManagerModules/gbar
    ./homeManagerModules/nvim
    ./homeManagerModules/tmux-sessionizer
  ]; 

  home.username = "senyc";
 
  alacritty.enable = true;
  tmux.enable = true;
  zsh.enable = true;
  git.enable = true;
  wofi.enable = true;
  hyprland.enable = true;
  gbar.enable = true;
  nvim.enable = true;
  tmux-sessionizer.enable = true;

  home.homeDirectory = "/home/senyc";

  home.stateVersion = "23.11"; # Probably don't change this

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    brave
    slack
    spotify
    neofetch
    pamixer
    playerctl
    aspell
    swww
    wl-clipboard
    slurp
    grim
    (writeShellScriptBin "rebuild" ''
      sudo nixos-rebuild switch --flake $HOME/nixconfig#default
    '')
    (writeShellScriptBin "screenshot" ''
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0)" - | wl-copy
     '')
  ];

# Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
