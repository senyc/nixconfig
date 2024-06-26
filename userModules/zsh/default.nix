{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.user.zsh.enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf config.modules.user.zsh.enable {
    home.file = {
      ".p10k.zsh" = {
        source = ./.p10k.zsh;
      };
    };
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
        v = "nvim";
        k = "kubectl";
        g = "git";
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
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
        "......" = "../../../../..";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initExtra = ''
        # This will auto select the first item on tab
        setopt menu_complete

        # Add powerlevel10k configuration
        source ~/.p10k.zsh

        cdp() {
          if [ -n "$1" ]; then
            case $1 in
              "--help")
              echo "Gets current tmux project and sets current directory to the project directory"
              return
              ;;
          -*)
            echo "Gets current tmux project and sets current directory to the project directory"
            return
            ;;
          esac
            return
            fi

            project_name=$(tmux display-message -p '#S')
            if [[ "$project_name" == "main" ]]; then
              cd $HOME
                return
                elif [[ "$project_name" == "nixconfig" ]]; then
                cd "$HOME/nixconfig/"
                return
                fi
                # This may cause issues where the order of similar named projects will impact outcome
                # This would be fixed by better regex
                project_path="$HOME/projects/$project_name"
                work_path="$HOME/work/$project_name"
                if [ -d "$project_path" ]; then
                  cd "$project_path" || return
                    elif [ -d "$work_path" ]; then
                    cd "$work_path" || return
                else
                  echo "Can't find base project path, are you sure one exists?"
                    fi
        }
      '';
    };
  };
}
