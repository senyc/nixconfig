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
      hosts = {
        "100.76.122.59" = [
          "vault"
        ];
        "100.107.64.116" = [
          "server"
        ];
      };
    };
  };
}
