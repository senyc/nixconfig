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
    # TODO figure out why this works
    environment.etc = {
      "resolv.conf".text = "nameserver 8.8.8.8\n";
    };
  };
}
