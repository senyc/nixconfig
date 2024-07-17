{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.gh.enable = lib.mkEnableOption "Enable github commandline tool";
  };
  config = lib.mkIf config.modules.user.gh.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
