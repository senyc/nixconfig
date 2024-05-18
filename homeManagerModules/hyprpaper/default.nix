{
  config,
  lib,
  ...
}: {

  options = {
    hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
  };

  config = let
    wallpaper = ../../backgrounds/primary_background.png;
  in
    lib.mkIf config.hyprpaper.enable {
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
