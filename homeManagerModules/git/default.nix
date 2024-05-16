{
  config,
  lib,
  ...
}: {
  options = {
    git.enable = lib.mkEnableOption "Enable git";
  };
  config = lib.mkIf config.git.enable {
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
