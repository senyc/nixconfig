{
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ./greetd
    ./keepassxc
  ];

  # Nix configurations
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs = {
    config = {
      # Setting this to true causes issues with some packages (namely orc 0.4.38)
      enableParallelBuildingByDefault = false;
    };
  };

  greeter.enable = true;
  keepassxc.enable = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "senyc" = import ./home.nix;
    };
  };


  hardware = {
    opengl.enable = true;
  };
  system.stateVersion = "23.11"; # Don't delete this
}
