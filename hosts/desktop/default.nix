{
  inputs,
  outputs,
  ...
}: let
  utils = import ../../nix/utils.nix {inherit inputs outputs;};
  systemModules = [
    "disk"
    "general"
    "greetd"
    "keepassxc"
    "network"
    "packages"
    "users"
    "containerization"
    "steam"
    "wayland"
    "pipewire"
  ];
  userModules =
    [
      "unfreePackages"
      "chromium"
      "cursor"
      "direnv"
      "gbar"
      "gh"
      "dev"
      "git"
      "kitty"
      "packages"
      "scripts"
      "wofi"
      "zsh"
    ]
    ++ map (i: "hypr${i}") ["idle" "paper" "lock" "land"];
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
