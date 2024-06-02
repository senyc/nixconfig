{
  inputs,
  outputs,
  pkgs,
  ...
}: let
  utils = import ../../nix/utils.nix {inherit inputs outputs pkgs;};
  nixosModules = [
    "disk"
    "general"
    "greetd"
    "keepassxc"
    "network"
    "packages"
    "services"
    "sops"
    "users"
    "virtual"
    "wayland"
  ];
  homeManagerModules =
    [
      "alacritty"
      "cursor"
      "gbar"
      "git"
      "nvim"
      "packages"
      "scripts"
      "tmux"
      "wofi"
      "zsh"
    ]
    ++ map (i: "hypr${i}") ["idle" "paper" "lock" "land"];
in
  utils.addNixosModules nixosModules {
    imports = [
      ./hardware-configuration.nix
      inputs.disko.nixosModules.default
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      users = {
        "senyc" = utils.addHomeManagerModules homeManagerModules {
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
