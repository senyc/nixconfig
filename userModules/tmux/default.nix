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
      prefix = "C-f";
      shell = "${pkgs.zsh}/bin/zsh";
      escapeTime = 10;
      disableConfirmationPrompt = true;
      newSession = false;
      plugins = with pkgs; [
        tmuxPlugins.yank
      ];
      extraConfig = /*tmux*/''
        if-shell '[ -f ~/.tmux-extra-bindings ]' 'source-file ~/.tmux-extra-bindings'
        set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc"

        # vim like pane switching
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        set -g status-position top
        set -g status-justify absolute-centre
        set -g status-style 'fg=color7 bg=default'
        set -g status-left '#S'
        set -g status-right ""
        set -g status-left-style 'fg=color8'
        set -g status-right-length 0
        set -g status-left-length 100
        setw -g window-status-current-style 'fg=colour6 bg=default bold'
        setw -g window-status-current-format '#I:#W '
        setw -g window-status-style 'fg=color8'

        set-option -sa terminal-features ',xterm-256color:RGB'
        set-option -g allow-passthrough on
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q' # This is for the cursor shape in nvim
        set -g renumber-windows on   # renumber all windows when any window is closed
        set -g escape-time 0         # zero-out escape time delay
        set-window-option -g mode-keys vi

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        bind -r f run-shell "tmux neww tmux-sessionizer"

        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind -r "<" swap-window -d -t -1
        bind -r ">" swap-window -d -t +1
        # bind - switch-client -l
      '';
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "tmux-sessionizer" /*bash*/''
        fuzzy_find_projects() {
          # echo -e "$(find ~/p ~/p/archive ~/w ~/w/archive -mindepth 1 -maxdepth 1 -type d \( -path ~/w/archive -o -path ~/p/archive \) -prune -o -print | sed "s|$HOME|~|g")" | ${fzf}/bin/fzf --cycle;
          echo -e "$(find ~/p ~/w -mindepth 1 -maxdepth 1 -type d | sed "s|$HOME|~|g")" | ${fzf}/bin/fzf --cycle;
        }
        if [[ $# -eq 1 ]]; then
          selected=$1
        else
          selected=$(fuzzy_find_projects)
        fi

        if [[ -z $selected ]]; then
            exit 0
        fi

        selected=$(echo -e $selected | sed "s|~|"$HOME"|")
        # If there is a period in the name, remove it
        selected_name=$(basename "$selected" | tr . _)

        if [[ -z $TMUX ]] && [[ -z $(pgrep tmux) ]]; then
            tmux new-session -s "$selected_name" -c "$selected"
            exit 0
        fi

        if ! tmux has-session -t="$selected_name" 2> /dev/null; then
            tmux new-session -ds "$selected_name" -c "$selected"
        fi

        if [[ -z $TMUX ]]; then
            tmux attach-session -t $selected_name
        else
            tmux switch-client -t $selected_name
        fi
      '')
    ];
  };
}
