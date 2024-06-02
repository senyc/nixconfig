{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.virtual.enable = mkEnableOption "Enable default virtualization services";
  };
  config = mkIf config.modules.system.virtual.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };
  };
}
