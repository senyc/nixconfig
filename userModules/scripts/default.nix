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
