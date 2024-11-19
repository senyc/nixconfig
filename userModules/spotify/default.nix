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
        device = {
          volume = 100;
        };
      };
    };
  };
}
