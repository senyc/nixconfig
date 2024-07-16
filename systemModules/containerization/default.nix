{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.containerization.enable = mkEnableOption "Enable default containerization services";
  };
  config = mkIf config.modules.system.containerization.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
