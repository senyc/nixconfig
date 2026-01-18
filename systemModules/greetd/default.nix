{
  config,
  pkgs,
  lib,
  ...
}: let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/start-hyprland";
in {
  options = {
    modules.system.greetd.enable = lib.mkEnableOption "Enable the greeter";
  };
  config = lib.mkIf config.modules.system.greetd.enable {
    # Silence boot output so it doesn't overlap with greetd
    boot.kernelParams = [
      "quiet"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --time --cmd '${session} > /dev/null'";
          user = "greeter";
        };
      };
    };
  };
}
