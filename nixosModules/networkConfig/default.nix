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
        "127.0.0.1" = ["instagram.com" "www.instagram.com" "https://www.youtube.com" "news.google.com" "reddit.com" "www.news.google.com"  "finance.google.com" "www.finance.google.com" "https://youtube.com" "www.reddit.com"];
      };
    };
  };
}
