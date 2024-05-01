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
        "127.0.0.1" = ["https://youtube.com" "https://www.youtube.com" "news.google.com" "www.news.google.com" "www.youtube.com" "youtube.com" "www.reddit.com" "reddit.com"];
      };
    };
  };
}
