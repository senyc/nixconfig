{
  config,
  lib,
  ...
}: {
  options = {
    hypridle.enable = lib.mkEnableOption "Enable hypridle";
  };

  config = lib.mkIf config.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
        ];
      };
    };
  };
}
