{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    userConfig.enable = mkEnableOption "Enable default user configurations";
  };
  config = mkIf config.userConfig.enable {
    users = {
      mutableUser = false;
      users.senyc = {
        isNormalUser = true;
        uid = 1000;
        home = "/home/senyc";
        createHome = true;
        extraGroups = ["wheel" "networkmanager" "docker"];
        initialPassword = "password";
        shell = pkgs.zsh;
      };
    };
  };
}
