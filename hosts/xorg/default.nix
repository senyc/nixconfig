{
  inputs,
  outputs,
  ...
}: let
  utils = import ../../nix/utils.nix {inherit inputs outputs;};
  systemModules = [
    "disk"
    "general"
    "keepassxc"
    "network"
    "packages"
    "services"
    "sops"
    "users"
    "virtual"
    "xorg"
  ];
  userModules = [
    "alacritty"
    "chromium"
    "cursor"
    "git"
    "nvim"
    "packages"
    "scripts"
    "tmux"
    "wofi"
    "zsh"
  ];
in
  utils.addSystemModules systemModules {
    imports = [
      ./hardware-configuration.nix
      inputs.disko.nixosModules.default
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      users = {
        "senyc" = utils.addUserModules userModules {
          home = rec {
            username = "senyc";
            homeDirectory = "/home/${username}";
            stateVersion = "23.11";
          };

          programs.home-manager.enable = true;
        };
      };
    };
    system.stateVersion = "23.11";
  }
