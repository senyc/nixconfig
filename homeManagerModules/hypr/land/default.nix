{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "Enable hyprland";
  };
  config = let
    pointer = config.home.pointerCursor;
  in lib.mkIf config.hyprland.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "showdesktop" ''
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
          hyprctl dispatch movetoworkspace $current_workspace,pid:$pid
        }

        if [ -f "$stack_file" ]; then
          show_window > /dev/null
          rm "$stack_file"
        else
          hide_window > /dev/null
        fi
      '')
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 1;
          layout = "master";
          cursor_inactive_timeout = 10;
        };
        input = {
          follow_mouse = 1;
             touchpad = {
               natural_scroll = false;
             };
             repeat_rate = 40;
             repeat_delay = 300;
             force_no_accel = true;
             sensitivity = 0.8; # -1.0 - 1.0, 0 means no modification.
          };
          misc = {
            enable_swallow = true;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            vrr = 1;
            # swallow_regex = "^(Alacritty|wezterm)$";
          };
          decoration = {
            rounding = 5;
            drop_shadow = true;
            shadow_range = 30;
            active_opacity = 0.85;
            inactive_opacity = 0.90;
            shadow_render_power = 3;
            "col.shadow" = "rgba(1a1a1aee)";
          };
          animations = {
            enabled = true;
            bezier = "myBezier, 0.25, 0.9, 0.1, 1.02";
            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 7, myBezier, slidefade"
            ];
          };
          dwindle = {
            pseudotile = true; # master switch for pseudotiling. Enabling is bound to mod + P in the keybinds section below
            preserve_split = true; # you probably want this
          };
          master = {
            new_is_master = true;
            # orientation = "center";
          };
          gestures = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = false;
          };
          "$mod" = "SUPER";
          bind = [
            "$mod, X, killactive,"
            "$mod, D, exec, showdesktop"
            "$mod SHIFT, M, exit,"
            "$mod, F, fullscreen, 1"
            "$mod SHIFT, F, fullscreen, 0"
            "$mod SHIFT, O, toggleopaque"
            # "$mod, G, togglegroup,"
            "$mod, bracketleft, changegroupactive, b"
            "$mod, bracketright, changegroupactive, f"
            "$mod, P, pin, active"

            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            "$mod, H, movefocus, l"
            "$mod, L, movefocus, r"
            "$mod, K, movefocus, u"
            "$mod, J, movefocus, d"

            "$mod SHIFT, H, movewindow, l"
            "$mod SHIFT, L, movewindow, r"
            "$mod SHIFT, K, movewindow, u"
            "$mod SHIFT, J, movewindow, d"
          ] ++ [
             # Scroll through existing workspaces with mod + scroll
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"

            "$mod, I, workspace, 1"
            "$mod, R, workspace, 2"
            "$mod, V, workspace, 3"
            "$mod, O, workspace, 4"
            "$mod, N, workspace, 5"

          ] ++ [
            ",XF86AudioRaiseVolume, exec, pamixer -i 2"
            ",XF86AudioLowerVolume, exec, pamixer -d 2"
            ",XF86AudioMute, exec, pamixer -t"
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioNext, exec, playerctl next"
            ",XF86AudioPrev, exec, playerctl previous"
            ",Print,exec, screenshot"
          ];
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          env = [
            # "HYPRCURSOR_THEME,Bibata-Modern-Classic"
            # "HYPRCURSOR_SIZE,24"
          ];
          debug = {
            enable_stdout_logs = true;
            disable_logs = false;
          };
          binde = [
            "$mod CONTROL, L, resizeactive, 20 0"
            "$mod CONTROL, H, resizeactive, -20 0"
            "$mod CONTROL, K, resizeactive, 0 -20"
            "$mod CONTROL, J, resizeactive, 0 20"
          ];
          bindr = [
            "SUPER, SUPER_L, exec, pkill wofi || omnipicker"
            ];
          monitor = [
            ",highrr,auto,1"
          ];
          workspace = [
            "1 default:true, monitor:DP-2"
          ];
          windowrulev2 = [
            "workspace 1, class:^(Alacritty)$"          
            "workspace 2, class:^(brave-browser)$"      
            "workspace 3, title:^(Spotify( Premium)?)$" 
            "workspace 4, class:^(Slack)$"              
            "workspace 5, class:^(Logseq)$"              
            "workspace 6, class:^(org.keepassxc.KeePassXC)$"              
            "opacity 1.0 override 1.0 override, class:^(Alacritty)$"
          ];
          exec-once = with pkgs; [
            "[workspace 3 silent] spotify"                            
            "[workspace 2 silent] brave"                              
            "[workspace 4 silent] slack"                              
            "[workspace 6 silent] keepassxc"                              
            "alacritty -e tmux new -s main"                           
            "${hypridle}/bin/hypridle"
            "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
            "gBar bar 0"                                           
          ];
        };
     };
  }; 
}
