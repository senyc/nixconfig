{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.user.tmux.enable = lib.mkEnableOption "Enable tmux";
  };

  config = lib.mkIf config.modules.user.tmux.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-b";
      shell = "${pkgs.zsh}/bin/zsh";
      escapeTime = 10;
      disableConfirmationPrompt = true;
      newSession = true;
      plugins = with pkgs; [
        tmuxPlugins.yank
      ];
      extraConfig = ''
        set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc"
        # vim like pane switching
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        set -g pane-active-border-style "bg=default fg=#EBBCBA"

        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q' # This is for the cursor shape in nvim

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        bind-key -r f run-shell "tmux neww tmux-sessionizer"
        bind-key -r b run-shell "tmux neww tmux-sessionizer -"

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        set-option -g status off
      '';
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "tmux-sessionizer" ''
        fuzzy_find_projects() { echo -e "$(find ~/projects ~/work -mindepth 1 -maxdepth 1 -type d)\n/home/senyc/nixconfig\nmain" | ${fzf}/bin/fzf --cycle; }
        if [[ $# -eq 1 ]]; then
            if [[ "$1" == "-" ]]; then
                if [[ -n $TMUX ]]; then
                    # Gets the most recently used tmux session
                    selected=$(tmux list-sessions -F "#{session_name}:#{session_activity}" | sort -t':' -k2r | head -n2 | tail -n1 | cut -d: -f1)
                else
                    selected=$(fuzzy_find_projects)
                fi
            else
                selected=$1
            fi
        else
            selected=$(fuzzy_find_projects)
        fi

        if [[ -z $selected ]]; then
            exit 0
        fi
        # If there is a period in the name, remove it
        selected_name=$(basename "$selected" | tr -d .)

        if [[ -z $TMUX ]] && [[ -z $(pgrep tmux) ]]; then
            tmux new-session -s "$selected_name" -c "$selected"
            exit 0
        elif [[ -z $TMUX ]]; then
            tmux attach
        fi

        if ! tmux has-session -t="$selected_name" 2> /dev/null; then
            tmux new-session -ds "$selected_name" -c "$selected"
        fi

        tmux switch-client -t "$selected_name"
      '')
    ];
  };
}
