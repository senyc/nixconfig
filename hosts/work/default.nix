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
    "users"
    "containerization"
    "xorg"
    "pipewire"
  ];
  userModules = [
    "chromium"
    "cursor"
    "direnv"
    "git"
    "kitty"
    "packages"
    "scripts"
    "wofi"
    "work"
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
      extraSpecialArgs = {inherit inputs outputs;};
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
