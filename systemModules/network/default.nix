{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.network.enable = mkEnableOption "Enable default networking configuration";
  };

  config = mkIf config.modules.system.network.enable {
    networking = {
      hostName = "nixos";
      networkmanager.enable = true;
    };
  };
}
