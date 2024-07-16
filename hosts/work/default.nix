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
  ];
  userModules = [
    "kitty"
    "chromium"
    "cursor"
    "git"
    "nvim"
    "scripts"
    "wofi"
    "zsh"
    "work"
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
