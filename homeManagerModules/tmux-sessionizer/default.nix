{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
   tmux-sessionizer.enable = lib.mkEnableOption "Enable tmux-sessionizer";
};

  config = lib.mkIf config.tmux-sessionizer.enable {
    home.packages = with pkgs;[
    fzf
    (writeShellScriptBin "tmux-sessionizer" ''
      fuzzy_find_projects() { cat ~/projectdir <(echo "main") | ${fzf}/bin/fzf --cycle; }
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
