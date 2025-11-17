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
    services.postgresql.enable = true;
    services.davfs2.enable = true;
    services.nfs.server.enable = true;
    programs.nix-ld.enable = true;
    environment.systemPackages = with pkgs; [
      curl
      fd
      lsof
      gcc
      gnumake
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
    ];

    programs.zsh.enable = true;
  };
}
