{
  pkgs,
  config,
  lib,
  ...
}: {

  options = {
    zsh.enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf config.zsh.enable {
    home.file = {
      ".p10k.zsh" = {
        source = ./.p10k.zsh; 
      };
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      history = {
        extended = true;
        save = 50000;
        share = true;
        size = 100000;
      };
      defaultKeymap = "emacs";
      shellAliases = {
        ls = "ls --color=auto";
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

        ts = "tmux-sessionizer";
      };
      shellGlobalAliases = {
        "..."="../..";            
        "...."="../../..";         
        "....."="../../../..";     
        "......"="../../../../.."; 
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initExtra = ''
        source ~/.p10k.zsh
        '';
    };
  };
}
