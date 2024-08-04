{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    modules.user.cursor.enable = mkEnableOption "Enable cursor customizations";
  };

  config = lib.mkIf config.modules.user.cursor.enable {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.catppuccin-gtk.override {
       variant = "macchiato";
        };
        name = "catppuccin-macchiato-blue-standard";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
