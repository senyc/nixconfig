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
          "server"
        ];
        "100.107.64.116" = [
          "desktop"
        ];
        "100.73.169.95" = [
          "laptop"
        ];
      };
    };
  };
}
