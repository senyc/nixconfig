{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.user.ags.enable = lib.mkEnableOption "Enable ags";
  };

  config = lib.mkIf config.modules.user.ags.enable {
    programs.ags = {
      enable = true;
      configDir = ./config;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
        libdbusmenu-gtk3
      ];
    };
  };
}
