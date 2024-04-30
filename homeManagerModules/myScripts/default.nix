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
    home.packages = [
      (pkgs.writeShellScriptBin "rebuild" ''
        if [[ -z $1 ]]; then
          echo "Please enter the host you would like to rebuild"  >&2
          return
        fi
         set -e
         pushd ~/nixconfig/
         # Show changes
         git diff -U0

         echo "NixOS Rebuilding..."

         sudo nixos-rebuild switch --flake ~/nixconfig#$1 &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
         echo "NixOS Rebuilt, commiting changes"

         # Get current generation metadata
         current=$(nixos-rebuild list-generations --flake ~/nixconfig#default | grep current | awk '{print $1,"on " $3}')

         # Add the generation number to the commit message and add all changes to the commit
         git commit -am "feat: update $1 host generation to $current"
         popd
      '')
      (pkgs.writeShellScriptBin "screenshot" ''
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0)" - | ${pkgs.wl-clipboard}/bin/wl-copy
      '')
      (pkgs.writeShellScriptBin "rmdockercontainers" ''
        for i in $(${pkgs.docker}/bin/docker ps --all | awk '{print $1}' | tail -n +2); do
          ${pkgs.docker}/bin/docker rm $i
        done
      '')
    ];
  };
}
