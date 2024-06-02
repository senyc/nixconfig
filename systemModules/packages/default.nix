{
  pkgs,
  config,
  lib,
  outputs,
  ...
}:
with lib; {
  options = {
    modules.system.packages.enable = mkEnableOption "Enable root packages";
  };
  config = mkIf config.modules.system.packages.enable {
    # Add packages that are external to nixpkgs
    nixpkgs.overlays = [outputs.overlays.addPackages];

    environment.systemPackages = with pkgs; [
      curl
      docker-compose
      gcc
      go
      lm_sensors # run sudo sensors-detect initially then sensors to get results
      lua
      nodejs
      python3
      ripgrep
      sops
      tree
      unzip
      wget
      which
      zip
    ];

    # Required to add nix related functionality to path?
    programs.zsh.enable = true;
  };
}
