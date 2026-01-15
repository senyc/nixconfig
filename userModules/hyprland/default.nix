{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.user.hyprland.enable = lib.mkEnableOption "Enable hyprland";
  };
  config = let
    pointer = config.home.pointerCursor;
  in
    lib.mkIf config.modules.user.hyprland.enable {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          general = {
            gaps_in = 4;
            gaps_out = "4, 8, 8, 8";
            border_size = 1;
            layout = "dwindle";
            "col.active_border" = "0xff7f849c";
          };
          cursor = {
            inactive_timeout = 10;
          };
          input = {
            follow_mouse = 1;
            touchpad = {
              natural_scroll = false;
            };
            force_no_accel = true;
            sensitivity = 0.8; # -1.0 - 1.0, 0 means no modification.
            kb_options = "caps:escape";
          };
          misc = {
            focus_on_activate = true;
            enable_swallow = true;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            vrr = 1;
          };
          decoration = {
            rounding = 5;
            shadow = {
              range = 30;
              render_power = 3;
            };
          };
          animations = {
            enabled = false;
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
            force_split = 2;
          };
          # gestures = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            # workspace_swipe = false;
          # };
          "$mod" = "SUPER";
          "$browser" = "firefox";
          "$altbrowser" = "chromium --new-window";
          "$terminal" = "foot";
          bind =
            [
              "$mod, Q, exec, $terminal"
              "$mod, B, exec, $browser"

              "$mod, X, killactive,"
              "$mod SHIFT CONTROL, M, exit,"
              "$mod, F, fullscreen, 1"
              "$mod SHIFT, F, fullscreen, 0"
              "$mod, bracketleft, changegroupactive, b"
              "$mod, bracketright, changegroupactive, f"

              "$mod, H, movefocus, l"
              "$mod, L, movefocus, r"
              "$mod, K, movefocus, u"
              "$mod, J, movefocus, d"

              "$mod SHIFT, H, movewindow, l"
              "$mod SHIFT, L, movewindow, r"
              "$mod SHIFT, K, movewindow, u"
              "$mod SHIFT, J, movewindow, d"
              "$mod, P, pseudo, "

              "$mod, SEMICOLON, exec, pkill wofi || wofi --show=run"
              "$mod, s, exec, search"
              "$mod, c, exec, ${pkgs.mako}/bin/makoctl dismiss --all"
            ]
            ++ [
              # Scroll through existing workspaces with mod + scroll
              "$mod, mouse_down, workspace, e+1"
              "$mod, mouse_up, workspace, e-1"
              # Terminal
              "$mod, E, workspace, 1"
              "$mod SHIFT, E, movetoworkspace, 1"
              "$mod CONTROL, E, movetoworkspacesilent, 1"
              # Test
              #
              # This should only contain chrome windows
              #
              # This should be for things in active development
              # Some examples include:
              # 1. running application
              # 2. test metrics
              #
              # Basically if it isn't actively being worked on it should be removed from this workspace
              "$mod, T, workspace, 2"
              "$mod SHIFT, T, movetoworkspace, 2"
              "$mod CONTROL, T, movetoworkspacesilent, 2"
              # Browser
              # These can be things that hang around and do not need to be actively worked on
              #
              # Some examples include:
              # 1. Documentation related to a feature
              # 2. Random google search
              # 3. Email
              # 4. Virtual meeting, etc
              #
              # Basically if it is on the web and does not include the three things mentioned in Test
              "$mod, R, workspace, 3"
              "$mod SHIFT, R, movetoworkspace, 3"
              "$mod CONTROL, R, movetoworkspacesilent, 3"
              # Music
              "$mod, M, workspace, 4"
              "$mod SHIFT, M, movetoworkspace, 4"
              "$mod CONTROL, M, movetoworkspacesilent, 4"
              # Other (messaging like slack)
              "$mod, O, workspace, 5"
              "$mod SHIFT, O, movetoworkspace, 5"
              "$mod CONTROL, O, movetoworkspacesilent, 5"
              # Notes (obsidian)
              "$mod, N, workspace, 6"
              "$mod SHIFT, N, movetoworkspace, 6"
              "$mod CONTROL, N, movetoworkspacesilent, 6"
            ]
            ++ [
              # Screenshot
              ",Print, exec, screenshot"
              # GIF recording (press once to start, again to stop)
              "SHIFT, Print, exec, gifrecord"
            ];
          # l flag will allow for these to be used while screen is locked
          bindl = [
            ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
            ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
            ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
            ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ];
          bindle = [
            ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 2"
            ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 2"
          ];
          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];
          debug = {
            enable_stdout_logs = false;
            disable_logs = true;
          };
          binde = [
            "$mod CONTROL, L, resizeactive, 20 0"
            "$mod CONTROL, H, resizeactive, -20 0"
            "$mod CONTROL, K, resizeactive, 0 -20"
            "$mod CONTROL, J, resizeactive, 0 20"
          ];
          monitor = [
            ",preferred,auto,1"
          ];
          # workspace = [
          #   "1 default:true, monitor:DP-2"
          # ];
          windowrulev2 = [
            "workspace 4, title:^(Spotify( Premium)?)$"
            "workspace 5, class:^(Slack)$"
            "workspace 6, class:^(obsidian)$"
            "float, class:^(.blueman-manager-wrapped)$"
            "float, class:^(.org.pulseaudio.pavucontrol)$"
            "size 30% 30%, class:^(.blueman-manager-wrapped)$"
            "size 30% 30%, class:^(.org.pulseaudio.pavucontrol)$"
          ];
          exec-once = [
            "waybar"
            "[workspace 4 silent] spotify"
            "[workspace 2 silent] $altbrowser"
            "[workspace 3 silent] $browser"
            "[workspace 6 silent] obsidian"
            # Attaches to tmux session
            ''sh -c 'export TMUX_TMPDIR=/run/user/1000; $terminal' ''

            "${pkgs.hypridle}/bin/hypridle"
            "${pkgs.hyprsunset}/bin/hyprsunset"
            "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
            # Adds blueman to the top bar
            "blueman-applet"
          ];
        };
      };
    };
}
