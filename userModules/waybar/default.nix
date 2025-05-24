{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    modules.user.waybar.enable = lib.mkEnableOption "Enable waybar";
  };
  config = let
    timerScript = pkgs.writeShellScript "timer.sh" ''
                  #!/usr/bin/env bash

                  format_time() {
                    local total_seconds=$1
                    local minutes=$((total_seconds / 60))
                    local seconds=$((total_seconds % 60))
                    echo "''${minutes}m ''${seconds}s"
                  }

                  to_minutes() {
                    local seconds=$1
                    echo "$(( (seconds + 59) / 60 ))m"
                  }

                  # Use a safe, user-writable temporary location
                  TIMER_DIR="''${XDG_RUNTIME_DIR:-$HOME/.cache}/"
                  TIMER_FILE="$TIMER_DIR/timer_state"
                  TIMER_STATUS="$TIMER_DIR/timer_status"

                  # If state and status files do not exist create them
                  if  [[ ! -e "$TIMER_FILE" ]]; then
                      echo $((30 * 60)) > "$TIMER_FILE"
                  fi

                  if  [[ ! -e "$TIMER_STATUS" ]]; then
                      echo "READY" > "$TIMER_STATUS"
                  fi


                  STATUS="$(cat "$TIMER_STATUS")"
                  CURRENT_TIMER=$(cat "$TIMER_FILE")

                  case "$1" in
                    up)
                        if [[ "$STATUS" == "ACTIVE" ]]; then
                            ${pkgs.libnotify}/bin/notify-send "Timer" "Timer is active, cannot increase time."
                            exit 1
                        fi

                        if [[ -z $CURRENT_TIMER ]]; then
                            CURRENT_TIMER=0
                        fi

                        NEW_TIMER=$((CURRENT_TIMER + (5 * 60)))
                        echo "$NEW_TIMER" > "$TIMER_FILE"
                          cat <<EOF
                          {"text":"$(to_minutes "$NEW_TIMER")","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF
                        ;;

                    down)
                        if [[ "$STATUS" == "ACTIVE" ]]; then
                            ${pkgs.libnotify}/bin/notify-send "Timer" "Timer is active, cannot decrease time."
                            exit 1
                        fi

                        if [[ -z $CURRENT_TIMER ]]; then
                            CURRENT_TIMER=0
                        fi

                        NEW_TIMER=$((CURRENT_TIMER - (5 * 60)))
                        echo "$NEW_TIMER" > "$TIMER_FILE"
                          cat <<EOF
                          {"text":"$(to_minutes "$NEW_TIMER")","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF
                        ;;
                    toggle)
                        if [[ "$STATUS" == "ACTIVE" ]]; then
                          echo "STOPPED" > "$TIMER_STATUS"
                          cat <<EOF
                          {"text":"󱡥","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF
                        else
                          echo "ACTIVE" > "$TIMER_STATUS"
                                cat <<EOF
                                {"text":"$(to_minutes "$CURRENT_TIMER")","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF
                        fi
                    ;;
                  reset)
                      echo "READY" > "$TIMER_STATUS"
                      NEW_TIMER=$((30 * 60 ))
                      echo "$NEW_TIMER" > "$TIMER_FILE"
                          cat <<EOF
                          {"text":"","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF
                      exit 0
                  ;;
                    *)
                        # This will actually decrement the timer
                        if [[ "$STATUS" == "ACTIVE" ]]; then
                            if [[ "$CURRENT_TIMER" -gt 1 ]]; then
                                NEW_TIMER=$((CURRENT_TIMER - 1))
                                echo "$NEW_TIMER" > "$TIMER_FILE"
                                CURRENT_TIMER=$(cat "$TIMER_FILE")
                            else
                                echo "COMPLETED" > "$TIMER_STATUS"
                                ${pkgs.libnotify}/bin/notify-send "Timer" "Timer has completed."
                                cat <<EOF
                                {"text":"󰾨","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF
                                exit 0
                            fi
                                cat <<EOF
                                {"text":"$(to_minutes "$CURRENT_TIMER")","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF

                            exit 0
                        fi

                        if [[ "$STATUS" == "COMPLETED" ]]; then
                                cat <<EOF
                                {"text":"󰾨","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF

                        fi


                        if [[ "$STATUS" == "STOPPED" ]]; then
                          cat <<EOF
                          {"text":"󱡥","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF
                        fi

                        if [[ "$STATUS" == "READY" ]]; then
                          cat <<EOF
                          {"text":"","tooltip":"$(format_time "$CURRENT_TIMER")"}
      EOF
                        fi
                        ;;
                  esac
    '';
  in
    lib.mkIf config.modules.user.waybar.enable {
      home.packages = [pkgs.libnotify];

      services.swaync = {
        enable = true;
        style = ''
          * {
            all: unset;
            font-size: 14px;
            font-family: "Ubuntu Nerd Font";
            transition: 200ms;
          }

          trough highlight {
            background: #cdd6f4;
          }

          scale trough {
            margin: 0rem 1rem;
            background-color: #313244;
            min-height: 8px;
            min-width: 70px;
          }

          slider {
            background-color: #89b4fa;
          }

          .floating-notifications.background .notification-row .notification-background {
            box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #313244;
            border-radius: 12.6px;
            margin: 18px;
            background-color: #1e1e2e;
            color: #cdd6f4;
            padding: 0;
          }

          .floating-notifications.background .notification-row .notification-background .notification {
            padding: 7px;
            border-radius: 12.6px;
          }

          .floating-notifications.background .notification-row .notification-background .notification.critical {
            box-shadow: inset 0 0 7px 0 #f38ba8;
          }

          .floating-notifications.background .notification-row .notification-background .notification .notification-content {
            margin: 7px;
          }

          .floating-notifications.background .notification-row .notification-background .notification .notification-content .summary {
            color: #cdd6f4;
          }

          .floating-notifications.background .notification-row .notification-background .notification .notification-content .time {
            color: #a6adc8;
          }

          .floating-notifications.background .notification-row .notification-background .notification .notification-content .body {
            color: #cdd6f4;
          }

          .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
            min-height: 3.4em;
          }

          .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
            border-radius: 7px;
            color: #cdd6f4;
            background-color: #313244;
            box-shadow: inset 0 0 0 1px #45475a;
            margin: 7px;
          }

          .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
            box-shadow: inset 0 0 0 1px #45475a;
            background-color: #313244;
            color: #cdd6f4;
          }

          .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
            box-shadow: inset 0 0 0 1px #45475a;
            background-color: #74c7ec;
            color: #cdd6f4;
          }

          .floating-notifications.background .notification-row .notification-background .close-button {
            margin: 7px;
            padding: 2px;
            border-radius: 6.3px;
            color: #1e1e2e;
            background-color: #f38ba8;
          }

          .floating-notifications.background .notification-row .notification-background .close-button:hover {
            background-color: #eba0ac;
            color: #1e1e2e;
          }

          .floating-notifications.background .notification-row .notification-background .close-button:active {
            background-color: #f38ba8;
            color: #1e1e2e;
          }

          .control-center {
            box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #313244;
            border-radius: 12.6px;
            margin: 18px;
            background-color: #1e1e2e;
            color: #cdd6f4;
            padding: 14px;
          }

          .control-center .widget-title > label {
            color: #cdd6f4;
            font-size: 1.3em;
          }

          .control-center .widget-title button {
            border-radius: 7px;
            color: #cdd6f4;
            background-color: #313244;
            box-shadow: inset 0 0 0 1px #45475a;
            padding: 8px;
          }

          .control-center .widget-title button:hover {
            box-shadow: inset 0 0 0 1px #45475a;
            background-color: #585b70;
            color: #cdd6f4;
          }

          .control-center .widget-title button:active {
            box-shadow: inset 0 0 0 1px #45475a;
            background-color: #74c7ec;
            color: #1e1e2e;
          }

          .control-center .notification-row .notification-background {
            border-radius: 7px;
            color: #cdd6f4;
            background-color: #313244;
            box-shadow: inset 0 0 0 1px #45475a;
            margin-top: 14px;
          }

          .control-center .notification-row .notification-background .notification {
            padding: 7px;
            border-radius: 7px;
          }

          .control-center .notification-row .notification-background .notification.critical {
            box-shadow: inset 0 0 7px 0 #f38ba8;
          }

          .control-center .notification-row .notification-background .notification .notification-content {
            margin: 7px;
          }

          .control-center .notification-row .notification-background .notification .notification-content .summary {
            color: #cdd6f4;
          }

          .control-center .notification-row .notification-background .notification .notification-content .time {
            color: #a6adc8;
          }

          .control-center .notification-row .notification-background .notification .notification-content .body {
            color: #cdd6f4;
          }

          .control-center .notification-row .notification-background .notification > *:last-child > * {
            min-height: 3.4em;
          }

          .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
            border-radius: 7px;
            color: #cdd6f4;
            background-color: #11111b;
            box-shadow: inset 0 0 0 1px #45475a;
            margin: 7px;
          }

          .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
            box-shadow: inset 0 0 0 1px #45475a;
            background-color: #313244;
            color: #cdd6f4;
          }

          .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
            box-shadow: inset 0 0 0 1px #45475a;
            background-color: #74c7ec;
            color: #cdd6f4;
          }

          .control-center .notification-row .notification-background .close-button {
            margin: 7px;
            padding: 2px;
            border-radius: 6.3px;
            color: #1e1e2e;
            background-color: #eba0ac;
          }

          .close-button {
            border-radius: 6.3px;
          }

          .control-center .notification-row .notification-background .close-button:hover {
            background-color: #f38ba8;
            color: #1e1e2e;
          }

          .control-center .notification-row .notification-background .close-button:active {
            background-color: #f38ba8;
            color: #1e1e2e;
          }

          .control-center .notification-row .notification-background:hover {
            box-shadow: inset 0 0 0 1px #45475a;
            background-color: #7f849c;
            color: #cdd6f4;
          }

          .control-center .notification-row .notification-background:active {
            box-shadow: inset 0 0 0 1px #45475a;
            background-color: #74c7ec;
            color: #cdd6f4;
          }

          .notification.critical progress {
            background-color: #f38ba8;
          }

          .notification.low progress,
          .notification.normal progress {
            background-color: #89b4fa;
          }

          .control-center-dnd {
            margin-top: 5px;
            border-radius: 8px;
            background: #313244;
            border: 1px solid #45475a;
            box-shadow: none;
          }

          .control-center-dnd:checked {
            background: #313244;
          }

          .control-center-dnd slider {
            background: #45475a;
            border-radius: 8px;
          }

          .widget-dnd {
            margin: 0px;
            font-size: 1.1rem;
          }

          .widget-dnd > switch {
            font-size: initial;
            border-radius: 8px;
            background: #313244;
            border: 1px solid #45475a;
            box-shadow: none;
          }

          .widget-dnd > switch:checked {
            background: #313244;
          }

          .widget-dnd > switch slider {
            background: #45475a;
            border-radius: 8px;
            border: 1px solid #6c7086;
          }

          .widget-mpris .widget-mpris-player {
            background: #313244;
            padding: 7px;
          }

          .widget-mpris .widget-mpris-title {
            font-size: 1.2rem;
          }

          .widget-mpris .widget-mpris-subtitle {
            font-size: 0.8rem;
          }

          .widget-menubar > box > .menu-button-bar > button > label {
            font-size: 3rem;
            padding: 0.5rem 2rem;
          }

          .widget-menubar > box > .menu-button-bar > :last-child {
            color: #f38ba8;
          }

          .power-buttons button:hover,
          .powermode-buttons button:hover,
          .screenshot-buttons button:hover {
            background: #313244;
          }

          .control-center .widget-label > label {
            color: #cdd6f4;
            font-size: 2rem;
          }

          .widget-buttons-grid {
            padding-top: 1rem;
          }

          .widget-buttons-grid > flowbox > flowboxchild > button label {
            font-size: 2.5rem;
          }

          .widget-volume {
            padding-top: 1rem;
          }

          .widget-volume label {
            font-size: 1.5rem;
            color: #74c7ec;
          }

          .widget-volume trough highlight {
            background: #74c7ec;
          }

          .widget-backlight trough highlight {
            background: #f9e2af;
          }

          .widget-backlight label {
            font-size: 1.5rem;
            color: #f9e2af;
          }

          .widget-backlight .KB {
            padding-bottom: 1rem;
          }

          .image {
            padding-right: 0.5rem;
          }
        '';
      };

      programs.waybar = {
        enable = true;
        settings = [
          {
            layer = "top";
            position = "left";
            margin = "5 2 5 6";
            reload-style-on-change = true;
            modules-left = [
              "hyprland/workspaces"
              "group/info"
            ];
            "modules-center" = [
              "clock"
            ];
            "modules-right" = [
              "group/sound"
              "tray"
            ];

            "hyprland/workspaces" = {
              format = "{icon}";
              on-click = "activate";
              all-outputs = true;
              persistent-workspaces = {
                "*" = 6;
              };
              activate-only = false;
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
              format-icons = {
                "1" = "e";
                "2" = "t";
                "3" = "r";
                "4" = "m";
                "5" = "g";
                "6" = "o";
              };
            };

            "group/sound" = {
              orientation = "inherit";
              modules = [
                "custom/timer"
                "group/audio"
                "custom/notifications"
              ];
            };

            "group/audio" = {
              orientation = "inherit";
              drawer = {
                transition-duration = 500;
                transition-left-to-right = false;
              };
              modules = [
                "wireplumber"
              ];
            };

            wireplumber = {
              min-length = 3;
              format = "{icon}";
              tooltip = true;
              format-muted = "󰖁";
              on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              format-icons = ["" ""];
              on-click-middle = "pavucontrol";
              on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              tooltip-format = "{node_name} | {volume}%";
              on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              smooth-scrolling-threshold = 1;
            };

            clock = {
              interval = 1;
              format = "{:%H\n%M\n%S}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "month";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  today = "<span color='#a6e3a1'><b><u>{}</u></b></span>";
                };
              };
            };

            "custom/timer" = {
              tooltip = true;
              format = "{}";
              return-type = "json";
              min-length = 3;
              exec = "${timerScript}";
              on-click = "${timerScript} toggle";
              on-click-right = "${timerScript} reset";
              on-click-middle = "${timerScript} reset";
              on-scroll-up = "${timerScript} up";
              on-scroll-down = "${timerScript} down";
              interval = 1;
            };

            "custom/notifications" = {
              tooltip = true;
              format = "{icon}";
              min-length = 3;
              format-icons = {
                notification = "<span foreground='red'><sup></sup></span>";
                none = "";
                dnd-notification = "<span foreground='red'><sup></sup></span>";
                dnd-none = "";
                inhibited-notification = "<span foreground='red'><sup></sup></span>";
                inhibited-none = "";
                dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
                dnd-inhibited-none = "";
              };
              return-type = "json";
              exec-if = "which ${pkgs.swaynotificationcenter}/bin/swaync-client";
              exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
              on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
              on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
              on-click-middle = "${pkgs.swaynotificationcenter}/bin/swaync-client -C -sw";
              escape = true;
            };

            tray = {
              spacing = 10;
            };
          }
        ];
        style =
          /*
          css
          */
          ''
                    * {
                      font-size: 20px;
                      font-family: "JetBrainsMono Nerd Font,JetBrainsMono NF";
                      min-width: 8px;
                      min-height: 0px;
                      border: none;
                      border-radius: 0;
                      box-shadow: none;
                      text-shadow: none;
                      padding: 0px;
                  }

                  window#waybar {
                    transition-property: background-color;
                    transition-duration: 0.5s;
                    border-radius: 8px;
                    border: 1px solid #7f849c;
                    background: #191919;
                    background: alpha(#191919, 0.9);
                    color: #cdd6f4;
              }

                menu,
                  tooltip {
                    border-radius: 8px;
                padding: 2px;
                  border: 1px solid #7f849c;
                  background: alpha(#191919, 0.9);

                  color: #cdd6f4;
            }

            menu label,
              tooltip label {
                font-size: 16px;
                  color: #cdd6f4;
            }

            #submap,
            #tray>.needs-attention {
              animation-name: blink-active;
                animation-duration: 1s;
                animation-timing-function: linear;
                animation-iteration-count: infinite;
                animation-direction: alternate;
              }

              .modules-right {
                margin: 0px 6px 6px 6px;
                border-radius: 4px;
                background: alpha(#191919, 0.4);
                color: #cdd6f4;
              }

              .modules-left {
                transition-property: background-color;
                  transition-duration: 0.5s;
                  margin: 6px 6px 6px 6px;
                border-radius: 4px;
                background: alpha(#191919, 0.4);
                color: #cdd6f4;
              }

              #custom-hotspot,
              #custom-github,
              #custom-notifications {
                font-size: 16px;

              }

              #custom-timer {
                font-size: 16px;
              }

              #wireplumber {
                font-size: 16px;
              }


              #custom-github {
                padding-top: 2px;
                padding-right: 4px;
              }

              #workspaces {
                margin: 0px 2px;
                padding: 4px 0px 0px 0px;
                border-radius: 8px;
              }

              #workspaces button {
                transition-property: background-color;
                transition-duration: 0.5s;
                color: #cdd6f4;
                background: transparent;
                border-radius: 4px;
                color: alpha(#cdd6f4, 0.3);
              }

              #workspaces button.urgent {
                font-weight: bold;
                color: #cdd6f4;
              }

              #workspaces button.active {
                padding: 4px 2px;
                background: alpha(#1e1e2e, 0.4);
                color: lighter(#cdd6f4);
                border-radius: 4px;
              }


              #tray {
                padding: 4px 0px 4px 0px;
              }



              #clock {
                font-weight: bold;
                padding: 4px 2px 2px 2px;
              }

              @keyframes blink-active {
                to {
                    background-color: #1e1e2e;
                    color: #c5c5c5;
                  }
            }

              @keyframes blink-red {
                to {
                    background-color: #c64d4f;
                    color: #c5c5c5;
                  }
            }

              @keyframes blink-yellow {
                to {
                    background-color: #cf9022;
                    color: #c5c5c5;
                  }
            }
          '';
      };
    };
}
