{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.gtk.enable = lib.mkEnableOption "Enable default gtk configuration";
  };

  config = lib.mkIf config.modules.user.gtk.enable {
    gtk = {
      enable = true;
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
