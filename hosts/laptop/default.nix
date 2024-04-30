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
    "virtualServices"
    "wayland"
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
      "nvim"
      "spicetify"
      "tmux"
      "wofi"
      "zsh"
      "zoxide"
    ]
    ++ map (i: "hypr${i}") ["idle" "paper" "lock" "land"];
in
  utils.addNixosModules nixosModules {
    imports = [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

    # Nix configurations
    nix.settings.experimental-features = ["nix-command" "flakes"];
    userConfig.enable = true;

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
