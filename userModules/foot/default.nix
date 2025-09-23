{
  lib,
  config,
  ...
}: {
  options = {
    modules.user.foot.enable = lib.mkEnableOption "Enable foot";
  };
  config = lib.mkIf config.modules.user.foot.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font Mono:size=15";
        };
      };
    };
  };
}
