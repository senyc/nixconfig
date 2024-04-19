{ 
  config, 
  pkgs, 
  inputs,
  ... 
}: {
  imports = [ 
    inputs.gBar.homeManagerModules.x86_64-linux.default 
    ./homeManagerModules/tmux
    ./homeManagerModules/alacritty
    ./homeManagerModules/zsh
    ./homeManagerModules/git
    ./homeManagerModules/wofi
    ./homeManagerModules/hyprland
    ./homeManagerModules/gbar
    ./homeManagerModules/nvim
    ./homeManagerModules/swaylock
  ]; 

  home.username = "senyc";
 
  alacritty.enable = true;
  tmux.enable = true;
  zsh.enable = true;
  git.enable = true;
  wofi.enable = true;
  hyprland.enable = true;
  gbar.enable = true;
  nvim.enable = true;
  swaylock.enable = true;

  home.homeDirectory = "/home/senyc";

  home.stateVersion = "23.11"; # Probably don't change this

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    brave
    slack
    spotify
    neofetch
    pamixer
    playerctl
    aspell
    wl-clipboard
    pavucontrol
    (writeShellScriptBin "rebuild" ''
      sudo nixos-rebuild switch --flake $HOME/nixconfig#default
    '')
    (writeShellScriptBin "screenshot" ''
      ${grim}/bin/grim -g "$(${slurp}/bin/slurp -w 0)" - | wl-copy
     '')
    (writeShellScriptBin "rmdockercontainers" ''
      for i in $(${docker}/bin/docker ps --all | awk '{print $1}' | tail -n +2); do
        ${docker}/bin/docker rm $i
      done
     '')
    (writeShellScriptBin "togglewindows" ''
      stack_file="/tmp/hide_window_pid_stack.txt"

      function hide_window(){
        pid=$(hyprctl activewindow -j | jq '.pid')
        hyprctl dispatch movetoworkspacesilent 88,pid:$pid
        echo $pid > $stack_file
      }

      function show_window(){
        pid=$(tail -1 $stack_file && sed -i '$d' $stack_file)
        [ -z $pid ] && exit

        current_workspace=$(hyprctl activeworkspace -j | jq '.id')	
        hyprctl dispatch movetoworkspacesilent $current_workspace,pid:$pid
      }

      if [ -f "$stack_file" ]; then
        show_window > /dev/null
        rm "$stack_file"
      else
        hide_window > /dev/null
      fi
     '')
  ];

# Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
