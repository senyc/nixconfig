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
        # Block list
        "127.0.0.1" = strings.splitString " " "youtube.com instagram.com twitch.tv www.youtube.com www.twitch.tv www.instagram.com https://www.youtube.com news.google.com www.news.google.com finance.google.com www.finance.google.com https://youtube.com reddit.com www.reddit.com";
      };
    };
  };
}
