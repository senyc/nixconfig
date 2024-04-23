{
  config,
  pkgs,
  lib,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
in {
  options = {
    greeter.enable = lib.mkEnableOption "Enable the greeter";
  };
  config = lib.mkIf config.greeter.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd ${session}";
          user = "greeter";
        };
      };
    };
  };
}
