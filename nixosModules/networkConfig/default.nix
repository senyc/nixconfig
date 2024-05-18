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
        "127.0.0.1" = ["instagram.com" "youtube.com" "www.youtube.com" "www.instagram.com" "https://www.youtube.com" "reddit.com" "www.reddit.com" "news.google.com" "www.news.google.com" "finance.google.com" "www.finance.google.com" "https://youtube.com" "twitch.tv" "www.twitch.tv"];
      };
    };
  };
}
