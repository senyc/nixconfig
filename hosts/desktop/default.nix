{
  inputs,
  outputs,
  pkgs,
  ...
}: let
  utils = import ../../nix/utils.nix {inherit inputs outputs pkgs;};
  nixosModules = [
    "keepassxc"
    "greetd"
    "general"
    "packages"
    "services"
    "users"
    "disk"
    "virtual"
    "wayland"
    "network"
    "sops"
  ];
  homeManagerModules = [
      "packages"
      "scripts"
      "alacritty"
      "cursor"
      "gbar"
      "git"
      "nvim"
      "tmux"
      "wofi"
      "zsh"
    ]
    ++ map (i: "hypr${i}") ["idle" "paper" "lock" "land"];
in
  utils.addSystemModules nixosModules {
    imports = [
      ./hardware-configuration.nix
      inputs.disko.nixosModules.default
      inputs.home-manager.nixosModules.default
    ];

    # Nix configurations
    nix.settings.experimental-features = ["nix-command" "flakes"];
    userConfig.enable = true;

    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      users = {
        "senyc" = utils.addUserModules homeManagerModules {
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
