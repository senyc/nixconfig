{
  pkgs,
    config,
    lib,
    ...
} : {
  options = {
    hypridle.enable = lib.mkEnableOption "Enable hypridle";
  };

  config = lib.mkIf config.hypridle.enable {
    services.hypridle = {
      lockCmd = "hyprlock";
      enable = true;
      listeners = [
        {
          timeout = 300;
          onTimeout = ''hyprlock'';
        }
      ];
    };
  };
}
