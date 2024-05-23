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
    "generalDesktop"
    "rootPackages"
    "rootServices"
    "userConfig"
    "primaryDiskPartitions"
    "virtualServices"
    "wayland"
    "rootImpermanence"
    "networkConfig"
  ];
  homeManagerModules =
    [
      "alacritty"
      "cursor"
      "gbar"
      "git"
      "homePackages"
      "myScripts"
      "homeImpermanence"
      "nvim"
      "tmux"
      "wofi"
      "zsh"
    ]
    ++ map (i: "hypr${i}") ["idle" "paper" "lock" "land"];
in
  utils.addNixosModules nixosModules {
    imports = [
      ./hardware-configuration.nix
      inputs.impermanence.nixosModules.impermanence
      inputs.disko.nixosModules.default
      inputs.home-manager.nixosModules.default
    ];

    # Nix configurations
    nix.settings.experimental-features = ["nix-command" "flakes"];
    userConfig.enable = true;

    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      users = {
        "senyc" = utils.addHomeManagerModules homeManagerModules {
          imports = [
            inputs.impermanence.nixosModules.home-manager.impermanence
          ];
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
