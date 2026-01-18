{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.initPackages.enable = mkEnableOption "Enable packages for boot initialization";
  };
  config = mkIf config.modules.system.initPackages.enable {
    environment.systemPackages = with pkgs; [
      curl
      git
      vim
    ];

    programs.zsh.enable = true;
  };
}
