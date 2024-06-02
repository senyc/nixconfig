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
    modules.system.greetd.enable = lib.mkEnableOption "Enable the greeter";
  };
  config = lib.mkIf config.modules.system.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --time --cmd ${session}";
          user = "greeter";
        };
      };
    };
  };
}
