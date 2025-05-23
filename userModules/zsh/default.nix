{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.zsh.enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf config.modules.user.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
      };
      history = {
        extended = true;
        save = 50000;
        share = true;
        size = 100000;
      };
      defaultKeymap = "emacs";
      shellAliases = {
        k = "kubectl";
        d = "docker";
        g = "git";
        la = "ls -a";
        gd = "git diff";
        gds = "git diff --staged";
        gs = "git status";
        gf = "git fetch";
        gsw = "git switch";
        gsw- = "git switch -";
        gc = "git commit";
        gca = "git commit --amend";
        gcae = "git commit --amend --no-edit";
        gcm = "git commit -m";
        gap = "git add -p";
        gaa = "git add --all";
        gcpm = "git cherry-pick -e -x -m 1";
      };
      sessionVariables  = {
        EDITOR = "nvim";
      };
      shellGlobalAliases = {
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
        "......" = "../../../../..";
      };
      initContent = /*bash*/''
        # This will auto select the first item on tab
        setopt menu_complete

        bindkey \^U backward-kill-line
        bindkey -s ^f "tmux-sessionizer\n"
      '';
    };
  };
}
