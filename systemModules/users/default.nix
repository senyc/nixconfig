{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    modules.system.users.enable = mkEnableOption "Enable default user configurations";
  };
  config = mkIf config.modules.system.users.enable {
    programs.zsh.enable = true;
    users = {
      mutableUsers = true;
      users.root = {
        home = "/root";
        initialPassword = "password";
      };
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
