{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    cursor.enable = mkEnableOption "Enable cursor customizations";
  };

  config = {
    gtk.enable = true;

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
