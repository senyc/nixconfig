{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    tmux.enable = lib.mkEnableOption "Enable tmux";
  };
  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-o";
      shell = "${pkgs.zsh}/bin/zsh";
      escapeTime = 10;
      disableConfirmationPrompt = true;
      plugins = with pkgs; [
        tmuxPlugins.yank
      ];
      extraConfig = ''
        # vim like pane switching
        bind h select-pane -L
        bind j select-pane -D 
        bind k select-pane -U
        bind l select-pane -R

        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q' # This is for the cursor shape in nvim

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"


        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        set-option -g status off
      '';
    };
  };
}
