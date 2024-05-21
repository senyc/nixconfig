{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    networkConfig.enable = mkEnableOption "Enable default networking configuration";
  };

  config = mkIf config.networkConfig.enable {
    networking = {
      hostName = "nixos";
      networkmanager.enable = true;
      hosts = {
        # Block list
        "127.0.0.1" = lib.strings.splitString " " "instagram.com twitch.tv www.twitch.tv www.instagram.com https://www.youtube.com news.google.com www.news.google.com finance.google.com www.finance.google.com https://youtube.com www.youtube.com youtube.com reddit.com www.reddit.com";
      };
    };
  };
}
