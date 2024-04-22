{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    zoxide.enable = lib.mkEnableOption "Enable Zoxide";
  };

  config = lib.mkIf config.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
