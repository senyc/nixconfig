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
    notificationScript = pkgs.writeShellScript "notification-icon.sh" ''
                  #!/usr/bin/env bash

                    ICON_NONE="󰂚"
                    ICON_UNREAD="<span color='#f9e2af'>󱅫</span>"
                    ICON_PAUSED=""

                    # Get notification history

                    # Default tooltip
                    tooltip="No notifications"

                    notifcations=$(${pkgs.swaync}/bin/swaync-client -c)

                    # Build tooltip if there are notifications
                    if [[ $notifcations == 1 ]]; then
                      tooltip="$notifcations notification"
                    fi

                    if [[ $notifcations -gt 1 ]]; then
                      tooltip="$notifcations notifcations"
                    fi

                    # Detect state and set icon
                    if [[ $(swaync-client -dn) == "true" ]]; then
                      icon="$ICON_PAUSED"
                    elif [[ $notifcations -gt 0 ]]; then
                      icon="$ICON_UNREAD"
                    else
                      icon="$ICON_NONE"
                    fi

                    # Output JSON for Waybar
                    # Safely escape tooltip for JSON
                    # escaped_tooltip=$(printf "%s\n<b>State</b>: %s" "$tooltip" "$state" | jq -R -s .)

                    # Output JSON for Waybar
                    cat <<EOF
                    {"text":"$icon","tooltip":"$tooltip"}
      EOF
    '';
  in
    lib.mkIf config.modules.user.waybar.enable {
      home.packages = [pkgs.libnotify];

      services.swaync = {
        enable = true;
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
                "*" = 5;
              };
              activate-only = false;
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
              format-icons = {
                "1" = "e";
                "2" = "t";
                "3" = "r";
                "4" = "m";
                "5" = "o";
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
