{
  inputs,
  outputs,
  ...
}: let
  utils = import ../../nix/utils.nix {inherit inputs outputs;};
  systemModules = [
    "unfreePackages"
    "disk"
    "general"
    "greetd"
    "network"
    "packages"
    "users"
    "containerization"
    "pipewire"
    "wayland"
    "tailscale"
    "steam"
    "nfs"
  ];
  userModules =
    [
      "unfreePackages"
      "firefox"
      "foot"
      "waybar"
      "cursor"
      "ssh"
      "direnv"
      "gh"
      "gtk"
      "dev"
      "git"
      "packages"
      "scripts"
      "wofi"
      "zsh"
      "starship"
      "tmux"
      "flameshot"
    ]
    ++ map (i: "hypr${i}") [
      "idle" "paper" "lock" "land"
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
            stateVersion = "25.05";
          };
          programs.home-manager.enable = true;
        };
      };
    };

    system.stateVersion = "23.11";
  }
