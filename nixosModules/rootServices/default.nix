{
  lib,
    config,
    ...
}: with lib; {
  options = {
    rootServices.enable = mkEnableOption "Enable default root services";
  };

  config = mkIf config.rootServices.enable {
    services = {
      printing.enable = true;
      openssh.enable = true;
    };
  };
}
