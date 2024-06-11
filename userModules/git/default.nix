{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.git.enable = lib.mkEnableOption "Enable git";
  };
  config = lib.mkIf config.modules.user.git.enable {
    programs.git = {
      enable = true;
      userName = "kyler";
      userEmail = "95313103+senyc@users.noreply.github.com";
      hooks = {
        commit-msg = ./commit-msg;
      };
      extraConfig = {
        core = {
          pager = "less";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
        url = {
          "git@github.com-personal:" = {
            insteadOf = "gh:";
          };
          "git@github.com-work:" = {
            insteadOf = "gw:";
          };
        };
      };
    };
  };
}
