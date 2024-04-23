{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprpaper.homeManagerModules.default
  ];

  options = {
    hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
  };

  config = let
    wallpaper = ../../../backgrounds/primary_background.png;
  in
    lib.mkIf config.hyprpaper.enable {
      services.hyprpaper = {
        enable = true;
        preloads = [
          "${wallpaper}"
        ];
        wallpapers = [
          "DP-2, ${wallpaper}"
        ];
      };
    };
}
