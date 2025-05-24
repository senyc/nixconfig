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
      (writeShellScriptBin "flameshotwayland" ''
        ${flameshotGrim}/bin/flameshot $@
      '')

      (writeShellScriptBin "makekeyfromssh" ''
        mkdir -p ~/.config/sops/age/
        nix run nixpkgs#ssh-to-age -- -private-key -i  ~/.ssh/id_personal > ~/.config/sops/age/keys.txt
        nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
      '')

      (writeShellScriptBin "addcookieexception" ''
        nix run nixpkgs#sqlite -- ~/projects/nixconfig/userModules/firefox/permissions.sqlite "INSERT INTO moz_perms (origin,type,permission,expireType,expireTime,modificationTime) VALUES ('https://$1','cookie',1,0,0,1737570736582); INSERT INTO moz_perms (origin,type,permission,expireType,expireTime,modificationTime) VALUES ('http://$1','cookie',1,0,0,1737570736582)"
      '')

      (writeShellScriptBin "getsecret" ''
        cat "/var/run/secrets/$1"
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

        # If file does not exist, create it
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
        BROWSER="firefox"  # Replace with your preferred browser (e.g., chromium, google-chrome)
        SEARCH_ENGINE="https://google.com/search?q="  # Replace with your preferred search engine

        # Run wofi in drun mode and capture user input
        # show items in the order that they are appended
        INPUT=$(tac "$CACHE_FILE" | wofi --dmenu  --prompt "Search:" --lines 5)

        # Exit if wofi is canceled
        if [ -z "$INPUT" ]; then
            exit 0
        fi

        if ! "$(cat "$CACHE_FILE")" | grep -q "$INPUT"; then
          echo "$INPUT" >> "$CACHE_FILE"
        fi

        if is_url "$INPUT"; then
          "$BROWSER" "$INPUT" &
        else
          "$BROWSER" "''${SEARCH_ENGINE}''${INPUT}" &
        fi
      '')
    ];
  };
}
