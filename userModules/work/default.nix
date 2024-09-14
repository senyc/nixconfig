{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    modules.user.work.enable = lib.mkEnableOption "Enable work configurations";
  };
  config = lib.mkIf config.modules.user.work.enable {
    # Enable work unfree packages
    allowedUnfree = ["upwork" "zoom" "vscode"];
    home.packages = with pkgs; [
      upwork
      goose
      zoom-us
      vscode
      peek
      sqlcmd
      flameshot
      azure-cli
    ];
  };
}
