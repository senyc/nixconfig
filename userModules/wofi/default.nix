{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.wofi.enable = lib.mkEnableOption "Enable wofi";
  };
  config = lib.mkIf config.modules.user.wofi.enable {
    programs.wofi = {
      enable = true;
      settings = {
        show = "dmenu";
        width = "25%";
        height = "19%";
        sort_order = "alphabetical";
        insensitive = true;
      };
    };
  };
}
