{
  lib,
  config,
  ...
}: {
  options = {
    modules.user.spotify.enable = lib.mkEnableOption "Enable Spotify player";
  };
  config = lib.mkIf config.modules.user.spotify.enable {
    programs.spotify-player = {
      enable = true;
      settings = {
        enable_notify = false;
        cover_img_scale =
          if config.modules.user ? "alacritty"
          then 1.0
          else 1.8;
        device = {
          volume = 100;
        };
      };
    };
  };
}
