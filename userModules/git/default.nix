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
      userName = "senyc";
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
          "ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
          "git@github.com:" = {
            insteadOf = "gh:";
          };
        };
      };
    };
  };
}
