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
    ];
  };
}
