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
    "keepassxc"
    "network"
    "packages"
    "users"
    "sops"
    "containerization"
    "wayland"
    "pipewire"
  ];
  userModules =
    [
      "unfreePackages"
      "chromium"
      "spotify"
      "ags"
      "cursor"
      "ssh"
      "direnv"
      "gh"
      "gtk"
      "dev"
      "git"
      "alacritty"
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
          imports = [inputs.ags.homeManagerModules.default];
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
