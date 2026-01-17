{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
  };

  config = let
    wallpaper = ../../backgrounds/city.png;
  in
    lib.mkIf config.modules.user.hyprpaper.enable {
      services.hyprpaper = {
        enable = true;
        settings = {
          splash = false;
          preload = [
            "${wallpaper}"
          ];
          wallpaper = {
            monitor = "";
            path = "${wallpaper}";
          };
        };
      };
    };
}
