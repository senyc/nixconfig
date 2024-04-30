{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    virtualServices.enable = mkEnableOption "Enable default virtualization services";
  };
  config = mkIf config.virtualServices.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };
  };
}
