{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    modules.user.cursor.enable = mkEnableOption "Enable cursor customizations";
  };

  config = lib.mkIf config.modules.user.cursor.enable {
    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
