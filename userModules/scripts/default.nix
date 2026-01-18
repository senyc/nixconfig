{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options = {
    modules.user.scripts.enable = mkEnableOption "Enable helper scripts";
  };
  config = mkIf config.modules.user.scripts.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "opengithub" ''

        cd $(tmux run "echo #{pane_start_path}")
        url=$(git remote get-url origin)

        if [[ $url == *github.com* ]]; then
            if [[ $url == git@* ]]; then
                url="''${url#git@}"
                url="''${url/:/\/}"
                url="https://$url"
            fi
            xdg-open "$url"
        else
            echo "This repository is not hosted on GitHub"
        fi
      '')

      (writeShellScriptBin "screenshot" ''
        if ! [[ -d "$HOME/Pictures/screenshots/" ]]; then
            mkdir -p "$HOME/Pictures/screenshots/"
        fi
        date_string=$(date +"%Y-%m-%d%H:%M:%S")
        ${grim}/bin/grim -g "$(${slurp}/bin/slurp -w 0 -b 80808044)" - | tee "$HOME/Pictures/screenshots/$date_string.png" | ${wl-clipboard}/bin/wl-copy
      '')

      (writeShellScriptBin "rmdockercontainers" ''
        for i in $(${docker}/bin/docker ps --all | awk '{print $1}' | tail -n +2); do
          ${docker}/bin/docker rm $i
        done
      '')

      (writeShellScriptBin "gifrecord" ''
        PID_FILE="/tmp/gifrecord.pid"
        INFO_FILE="/tmp/gifrecord.info"

        # Function to cleanup stale files
        cleanup_stale() {
            rm -f "$PID_FILE" "$INFO_FILE"
        }

        # Check if already recording
        if [ -f "$PID_FILE" ]; then
            pid=$(cat "$PID_FILE")

            # Check if process is still running
            if kill -0 "$pid" 2>/dev/null; then
                # Stop the recording
                kill -INT "$pid"

                # Give it a moment to finish writing
                sleep 1

                # Read saved info
                temp_video=$(sed -n '1p' "$INFO_FILE")
                temp_palette=$(sed -n '2p' "$INFO_FILE")
                output_gif=$(sed -n '3p' "$INFO_FILE")

                ${libnotify}/bin/notify-send "GIF Recorder" "Processing..."

                # Convert to GIF
                ${ffmpeg}/bin/ffmpeg -y -i "$temp_video" -vf "fps=15,scale=iw:-1:flags=lanczos,palettegen" "$temp_palette" 2>/dev/null
                ${ffmpeg}/bin/ffmpeg -i "$temp_video" -i "$temp_palette" -filter_complex "fps=15,scale=iw:-1:flags=lanczos[x];[x][1:v]paletteuse" -y "$output_gif" 2>/dev/null

                # Cleanup
                rm -f "$temp_video" "$temp_palette" "$PID_FILE" "$INFO_FILE"

                ${libnotify}/bin/notify-send "GIF Recorder" "GIF saved as $output_gif"
                exit 0
            else
                # Stale PID file
                cleanup_stale
            fi
        fi

        # Start new recording
        temp_video="/tmp/video_$(date +%s)_$RANDOM.mp4"
        output_gif="$HOME/Downloads/output_$(date +%Y%m%d_%H%M%S).gif"
        temp_palette=$(mktemp --suffix=.png)

        # Save info for later
        cat > "$INFO_FILE" << EOF
        $temp_video
        $temp_palette
        $output_gif
        EOF

        # Select area
        region=$(${slurp}/bin/slurp -w 0 -b 80808044)
        if [ -z "$region" ]; then
            ${libnotify}/bin/notify-send "GIF Recorder" "No region selected"
            cleanup_stale
            exit 1
        fi

        ${libnotify}/bin/notify-send "GIF Recorder" "Recording started. Run again to stop."

        # Start recording in background
        ${wf-recorder}/bin/wf-recorder -g "$region" -f "$temp_video" &
        echo $! > "$PID_FILE"
      '')

      (writeShellScriptBin "colorpicker" ''
        ${hyprpicker}/bin/hyprpicker -a
      '')

      (writeShellScriptBin "addcookieexception" ''
        nix run nixpkgs#sqlite -- ~/projects/nixconfig/userModules/firefox/permissions.sqlite "INSERT INTO moz_perms (origin,type,permission,expireType,expireTime,modificationTime) VALUES ('https://$1','cookie',1,0,0,1737570736582); INSERT INTO moz_perms (origin,type,permission,expireType,expireTime,modificationTime) VALUES ('http://$1','cookie',1,0,0,1737570736582)"
      '')

      (writeShellScriptBin "gfs" ''
        fetch_output=$(git fetch 2>&1)
        branches=$( echo "$fetch_output" | tail -n +2 | awk '{print $NF}' | sed 's|origin/||')

        if [[ -z $branches ]]; then
          echo "No branches found" >&2
          exit 1
        elif [[  $(echo $branches | wc -w) == 1  ]]; then
          branch_to_switch_to="$branches"
        else
          branch_to_switch_to="$(echo "$branches" | ${fzf}/bin/fzf --cycle )"
        fi

        git switch "$branch_to_switch_to"
      '')

      (writeShellScriptBin "ghid" ''
        print_help() {
          echo "usage: ghid issue [prefix]"
          echo
          echo "Creates and attaches a branch to the issue."
          echo "Checks out the created branch, if specified, will"
          echo "prepend the prefix in the form of <prefix>-<issue #>"
          echo "If not specified will default to the format of"
          echo "issue_<issue #>"
          echo
          echo "options"
          echo "  -h --help          Displays this help and exits"
        }

        if [[ "$1" =~ ^(-h|--help)$ ]]; then
          print_help
          exit 0
        fi

        if [[ -z $1 ]]; then
          print_help
          exit 1
        fi

        if [[ -n $2 ]]; then
          gh issue develop "$1" -c -n "$2-$1"
        else
          gh issue develop "$1" -c -n "issue_$1"
        fi
      '')

      # Simple reminder for available conventional commits (as based on angular commit convention)
      (writeShellScriptBin "commits" ''
        echo "-------------------Conventional commits------------------"
        echo "build: Changes that affect the build system"
        echo "ci: Changes to our CI configuration files and scripts"
        echo "docs: Documentation only changes"
        echo "feat: A new feature"
        echo "fix: A bug fix"
        echo "perf: A code change that improves performance"
        echo "refactor: A code change that neither fixes a bug nor adds a feature"
        echo "style: Changes that do not affect the function at all (white space, etc.)"
        echo "test: Adding missing tests or correcting existing tests"
        echo "revert: first include title of commit in the body include sha"
        echo "chore: grunt tasks; no production code change, e.g. update .gitignore, nothing main user would see"
        echo "---------------------------------------------------------"
      '')

      (writeShellScriptBin "search" ''
        CACHE_DIR="''${XDG_RUNTIME_DIR:-$HOME/.cache}/"
        CACHE_FILE="$CACHE_DIR/search"
        BOOKMARKS_FILE="$HOME/.bookmarks"

        # If cache file does not exist, create it
        if  [[ ! -e "$CACHE_FILE" ]]; then
          touch $CACHE_FILE
        fi

        is_url() {
          local input="$1"

          if [[ "$input" =~ ^(https?://)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$ ]]; then
            return 0  # true
          else
            return 1  # false
          fi
        }

        # Configuration
        BROWSER="firefox"
        SEARCH_ENGINE="https://google.com/search?q="

        # Build the list of options
        declare -A bookmark_map
        options=""

        # Read bookmarks if file exists
        if [[ -f "$BOOKMARKS_FILE" ]]; then
          while IFS= read -r line; do
            # Skip empty lines and comments
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

            # Parse "name => url" format
            if [[ "$line" =~ ^(.+)[[:space:]]*=\>[[:space:]]*(.+)$ ]]; then
              name="''${BASH_REMATCH[1]}"
              url="''${BASH_REMATCH[2]}"
              # Trim whitespace
              name="$(echo "$name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
              url="$(echo "$url" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
              bookmark_map["$name"]="$url"
              if [[ -n "$options" ]]; then
                options="$options"$'\n'
              fi
              options="$options$name"
            fi
          done < "$BOOKMARKS_FILE"
        fi

        # Add cached searches
        if [[ -f "$CACHE_FILE" && -s "$CACHE_FILE" ]]; then
          if [[ -n "$options" ]]; then
            options="$options"$'\n'
          fi
          options="$options$(tac "$CACHE_FILE")"
        fi

        # Run wofi to select
        INPUT=$(printf "%s" "$options" | wofi --dmenu --prompt "Search:" --no-sort)

        # Exit if wofi is canceled
        if [ -z "$INPUT" ]; then
            exit 0
        fi

        # Check if it's a bookmark
        if [[ -n "''${bookmark_map[$INPUT]}" ]]; then
          "$BROWSER" "''${bookmark_map[$INPUT]}" &
        else
          # Add to cache if not already there
          if ! grep -Fxq "$INPUT" "$CACHE_FILE" 2>/dev/null; then
            echo "$INPUT" >> "$CACHE_FILE"
          fi

          # Handle as URL or search query
          if is_url "$INPUT"; then
            "$BROWSER" "$INPUT" &
          else
            "$BROWSER" "''${SEARCH_ENGINE}''${INPUT}" &
          fi
        fi
      '')
    ];
  };
}
