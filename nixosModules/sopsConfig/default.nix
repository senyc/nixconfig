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
    sopsConfig.enable = mkEnableOption "Enable sops configuration";
  };

  config = mkIf config.sopsConfig.enable {
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/senyc/.config/sops/age/keys.txt";

    sops.age.generateKey = false;
    # This is the actual specification of the secrets.
    sops.secrets.spotify-password = {
      owner = config.users.users.senyc.name;
      group = config.users.users.senyc.group;
    };
    sops.secrets.spotify-username = {
      owner = config.users.users.senyc.name;
      group = config.users.users.senyc.group;
    };
  };
}
