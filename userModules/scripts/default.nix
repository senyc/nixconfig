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
        ${grim}/bin/grim -g "$(${slurp}/bin/slurp -w 0)" - | tee "$HOME/Pictures/screenshots/$date_string.png" | ${wl-clipboard}/bin/wl-copy
      '')

      (writeShellScriptBin "rmdockercontainers" ''
        for i in $(${docker}/bin/docker ps --all | awk '{print $1}' | tail -n +2); do
          ${docker}/bin/docker rm $i
        done
      '')

      (writeShellScriptBin "makekeyfromssh" ''
        mkdir -p ~/.config/sops/age/
        nix run nixpkgs#ssh-to-age -- -private-key -i  ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
        nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
      '')

      (writeShellScriptBin "getsecret" ''
        cat "/var/run/secrets/$1"
      '')

      (writeShellScriptBin "gfs" ''
        fetch_output=$(git fetch 2>&1)
        branches=$( echo "$fetch_output" | tail -n +2 | awk '{print $NF}' | sed 's|origin/||')

        # we can use wc to count lines if we want to later
        branch_to_switch_to=$(echo "$branches" | ${fzf}/bin/fzf --cycle )
        git switch "$branch_to_switch_to"
      '')

      (writeShellScriptBin "ghid" ''
        print_help() {
          echo "usage: ghid issue [suffix]"
          echo
          echo "Creates and attaches a branch to the issue."
          echo "Checks out the created branch, if specifed, will"
          echo "append the suffix in the form of <issue #>-<suffix>"
          echo "If not specified will default to the format of "
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
          gh issue develop "$1" -c -n "$1-$2"
          exit "$?"
        fi
        gh issue develop "$1" -c -n "issue_$1"
      '')

      # Simple reminder for available conventional commits (as based on angular commit convention)
      (writeShellScriptBin "commits" ''
        echo "--------------------Conventional commits--------------------"
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
    ];
  };
}
