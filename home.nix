{ 
  config, 
  pkgs, 
  inputs,
  ... 
}:
{
  imports = [ 
    inputs.gBar.homeManagerModules.x86_64-linux.default 
    ./homeManagerModules/alacritty
    ./homeManagerModules/zsh
    ./homeManagerModules/git
    ./homeManagerModules/wofi
    ./homeManagerModules/hyprland
    ./homeManagerModules/gbar
    ./homeManagerModules/nvim
    ./homeManagerModules/tmux
  ]; 

  home.username = "senyc";
 
 alacritty.enable = true;
 zsh.enable = true;
 git.enable = true;
 wofi.enable = true;
 hyprland.enable = true;
 gbar.enable = true;
 nvim.enable = true;
 tmux.enable = true;

 home.homeDirectory = "/home/senyc";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

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
      (writeShellScriptBin "rebuild" ''
        sudo nixos-rebuild switch --flake $HOME/nixconfig#default
      '')
  ];

  home.sessionVariables = {
     EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
