{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.hyprsunset.enable = lib.mkEnableOption "Enable hyprsunset";
  };

  config = lib.mkIf config.modules.user.hyprsunset.enable {
    services.hyprsunset = {
      enable = true;
      settings = {
        max-gamma = 150;

        profile = [
          {
            time = "8:30";
            identity = true;
          }
          {
            time = "21:00";
            temperature = 5000;
            gamma = 0.8;
          }
        ];
      };
    };
  };
}
