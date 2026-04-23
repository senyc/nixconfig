{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.ranger.enable = lib.mkEnableOption "Enable ranger";
  };

  config = lib.mkIf config.modules.user.ranger.enable {
    programs.ranger = {
      enable = true;
    };
  };
}
