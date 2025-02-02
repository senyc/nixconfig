{
  inputs,
  outputs,
  ...
}: let
  utils = import ../../nix/utils.nix {inherit inputs outputs;};
  systemModules = [
    "containerization"
    "disk"
    "general"
    "gnome"
    "keepassxc"
    "network"
    "packages"
    "pipewire"
    "users"
    "xorg"
    "tailscale"
  ];
  userModules = [
    "chromium"
    "cursor"
    "spotify"
    "dev"
    "direnv"
    "gh"
    "ssh"
    "git"
    "gtk"
    "alacritty"
    "packages"
    "scripts"
    "unfreePackages"
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

    # nvimconfig specific environment variable to only show work related projects in project search
    environment.sessionVariables = {
      HIDE_PERSONAL_PROJECTS = "true";
    };

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
