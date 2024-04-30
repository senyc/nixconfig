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
    # home.sessionVariables = {
    #   QT_SCALE_FACTOR = 1;
    #   ELM_SCALE = 1;
    #   GDK_SCALE = 1;
    #   XCURSOR_SIZE = 16;
    # };

    gtk.enable = true;

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 10;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
