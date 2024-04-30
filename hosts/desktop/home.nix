{
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: let 
  utils = import ../../nix/utils.nix {inherit inputs outputs pkgs;};
  homeManagerModules = ["alacritty" "cursor" "gbar" "git" "homePackages" "myScripts" "nvim" "spicetify" "tmux" "wofi" "zsh" "zoxide"] ++ (map (i: "hypr" + i) ["idle" "paper" "lock" "land"]);
in  utils.useModules homeManagerModules // {
  imports = utils.generateHomeManagerImports homeManagerModules;
  home = rec {
    username = "senyc";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;

}
