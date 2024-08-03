{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    modules.system.network.enable = mkEnableOption "Enable default networking configuration";
  };

  config = mkIf config.modules.system.network.enable {
    networking = {
      hostName = "nixos";
      networkmanager.enable = true;
      hosts = {
        "127.0.0.1" = strings.splitString " " "reddit.com www.reddit.com instagram.com twitch.tv www.twitch.tv www.instagram.com https://www.youtube.com youtube.com news.google.com www.news.google.com www.youtube.com finance.google.com www.finance.google.com https://youtube.com";
      };
    };
  };
}
