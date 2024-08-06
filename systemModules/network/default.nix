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
        "127.0.0.1" = strings.splitString " " "reddit.com instagram.com twitch.tv www.twitch.tv www.instagram.com www.reddit.com https://www.youtube.com news.google.com www.news.google.com finance.google.com www.finance.google.com https://youtube.com";
      };
    };
    # TODO figure out why this works
    environment.etc = {
      "resolv.conf".text = "nameserver 8.8.8.8\n";
    };
  };
}
