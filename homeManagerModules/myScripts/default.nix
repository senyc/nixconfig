{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options = {
    myScripts.enable = mkEnableOption "Enable helper scripts";
  };
  config = mkIf config.myScripts.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "rebuild" ''
        if [[ -z $1 ]]; then
          echo "Please enter the host you would like to rebuild"  >&2
          return
        fi
         set -e
         pushd ~/nixconfig/
         # Show changes
         git diff -U0

         echo "NixOS Rebuilding $1..."

         sudo nixos-rebuild switch --flake ~/nixconfig#$1 &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
         echo "NixOS Rebuilt, commiting changes"

         # Get current generation metadata
         current=$(nixos-rebuild list-generations --flake ~/nixconfig#default | grep current | awk '{print $1,"on " $3}')

         # Add the generation number to the commit message and add all changes to the commit
         git commit -am "feat: update $1 host generation to $current"
         popd
      '')
      (writeShellScriptBin "screenshot" ''
        ${grim}/bin/grim -g "$(${slurp}/bin/slurp -w 0)" - | ${wl-clipboard}/bin/wl-copy
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
      (writeShellScriptBin "authspotify" ''
       ${spotify}/bin/spotify --username="$(getsecret spotify-username)" --password="$(getsecret spotify-password)"
      '')
    ];
  };
}
