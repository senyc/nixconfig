{
  config,
  lib,
  ...
}: {

  options = {
    modules.user.hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
  };

  config = let
    wallpaper = ../../backgrounds/water.jpg;
  in
    lib.mkIf config.modules.user.hyprpaper.enable {
      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [
            "${wallpaper}"
          ];
          wallpaper = [
            ", ${wallpaper}"
          ];
        };
      };
    };
}
