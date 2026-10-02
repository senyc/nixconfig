{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
  };

  config = let
    wallpaper = ../../backgrounds/foggy_highland_trees_loch_tay.jpg;
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
