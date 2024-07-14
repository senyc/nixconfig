{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.packages.enable = mkEnableOption "Enable root packages";
  };
  config = mkIf config.modules.system.packages.enable {

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
      ruby
      sops
      tree
      unzip
      wget
      which
      zip
      gnumake
    ];

    # Required to add nix related functionality to path?
    programs.zsh.enable = true;
  };
}
