{
  pkgs,
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
      aliases = {
        br = "branch";
        ca = "commit --amend";
        cae = "commit --amend --no-edit";
        rb = "rebase";
        s = "status";
        sw = "switch";
        a = "add";
        ap = "add -p";
        aa = "add --all" ;
        c = "commit";
        cm = "commit -m";
        d = "diff";
        ds = "diff --staged";
        p = "push";
        ri = "rebase -i";
      };
      extraConfig = {
        core = {
          pager = "less";
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
