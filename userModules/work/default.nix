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
    nixpkgs.config.allowUnfreePredicate = pkg:
      lib.elem (lib.getName pkg) [
        "upwork"
        "zoom"
      ];
    home.packages = with pkgs; [
      upwork
      zoom-us
    ];
  };
}
