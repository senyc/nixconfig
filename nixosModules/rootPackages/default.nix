{
  pkgs,
  config,
  lib,
  outputs,
  ...
}:
with lib; {
  options = {
    rootPackages.enable = mkEnableOption "Enable root packages";
  };
  config = mkIf config.rootPackages.enable {
    # Add packages that are external to nixpkgs
    nixpkgs.overlays = [outputs.overlays.addPackages];

    # System packages
    environment.systemPackages = with pkgs; [
      myPackages.kx
      wget
      curl
      zip
      unzip
      which
      ripgrep
      jq
      lua
      python3
      go
      nodejs
      docker-compose
      lm_sensors # run sudo sensors-detect initially then sensors to get results
    ];

    # Required to add nix related functionality to path?
    programs.zsh.enable = true;
  };
}