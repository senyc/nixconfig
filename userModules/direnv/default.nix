{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.direnv.enable = lib.mkEnableOption "Enable direnv commandline tool";
  };
  config = lib.mkIf config.modules.user.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
