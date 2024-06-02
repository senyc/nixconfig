{
  lib,
    config,
    ...
}: with lib; {
  options = {
    modules.system.services.enable = mkEnableOption "Enable default root services";
  };

  config = mkIf config.modules.system.services.enable {
    services = {
      printing.enable = true;
      openssh.enable = true;
    };
  };
}
