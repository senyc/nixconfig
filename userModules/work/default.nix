{
  config,
  lib,
  pkgs,
  outputs,
  ...
}: {
  options = {
    modules.user.work.enable = lib.mkEnableOption "Enable work configurations";
  };
  config = lib.mkIf config.modules.user.work.enable {
    # Enable work unfree packages
    nixpkgs.overlays = [outputs.overlays.addPackages];
    allowedUnfree = ["upwork" "zoom" "vscode"];
    home.packages = with pkgs; [
      goose
      zoom-us
      vscode
      peek
      sqlcmd
      flameshot
      upwork
    ];
  };
}
