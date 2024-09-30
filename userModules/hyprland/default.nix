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
            layout = "master";
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
          };
          misc = {
            enable_swallow = true;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            vrr = 1;
          };
          decoration = {
            rounding = 5;
            drop_shadow = true;
            shadow_range = 30;
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
          gestures = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = false;
          };
          "$mod" = "SUPER";
          bind =
            [
              "$mod, Q, exec, alacritty"
              "$mod, B, exec, chromium"

              "$mod, X, killactive,"
              "$mod SHIFT, M, exit,"
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

              "$mod, SEMICOLON, exec, pkill wofi || wofi --show=run"
            ]
            ++ [
              # Scroll through existing workspaces with mod + scroll
              "$mod, mouse_down, workspace, e+1"
              "$mod, mouse_up, workspace, e-1"

              # Terminal
              "$mod, E, workspace, 1"
              # Browser
              "$mod, R, workspace, 2"
              # Music
              "$mod, M, workspace, 3"
              # Other
              "$mod, O, workspace, 4"
              # Notes
              "$mod, N, workspace, 5"
              # Passwords
              "$mod, P, workspace, 6"
            ]
            ++ [
              ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 2"
              ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 2"
              ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
              ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
              ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
              ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
              ",Print,exec, screenshot"
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
            ",highrr,auto,1"
          ];
          workspace = [
            "1 default:true, monitor:DP-2"
          ];
          windowrulev2 = [
            "workspace 3, title:^(Spotify( Premium)?)$"
            "workspace 4, class:^(Slack)$"
            "workspace 6, class:^(org.keepassxc.KeePassXC)$"
          ];
          exec-once = [
            "[workspace 3 silent] spotify"
            "[workspace 4 silent] slack"
            "[workspace 6 silent] keepassxc"
            "[workspace 2 silent] chromium"
            "[workspace 5 silent] logseq"
            "alacritty"

            "${pkgs.hypridle}/bin/hypridle"
            "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
            "ags"
          ];
        };
      };
    };
}
