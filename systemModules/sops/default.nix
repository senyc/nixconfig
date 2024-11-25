{
  lib,
  config,
  inputs,
  ...
}:
with lib; {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  options = {
    modules.system.sops.enable = mkEnableOption "Enable sops configuration";
  };

  config = mkIf config.modules.system.sops.enable {
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/senyc/.config/sops/age/keys.txt";
      age.generateKey = false;
      # This is the actual specification of the secrets.
      secrets.spotify-password = {
        owner = config.users.users.senyc.name;
        group = config.users.users.senyc.group;
      };
      secrets.spotify-username = {
        owner = config.users.users.senyc.name;
        group = config.users.users.senyc.group;
      };
      secrets.morning-tabs = {
        owner = config.users.users.senyc.name;
        group = config.users.users.senyc.group;
      };
    };
  };
}
