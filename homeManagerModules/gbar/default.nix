{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.gBar.homeManagerModules.x86_64-linux.default 
  ];

  options = {
    gbar.enable = lib.mkEnableOption "Enable gbar";
  };

  config = lib.mkIf config.gbar.enable {
    programs.gBar = {
      enable = true;
      config = {
          Location = "L";
          EnableSNI = true;
          WorkspaceSymbols = [ "" "" "" "󰭹" "" ];
          ExitCommand = "loginctl terminate-user $USER";
          DateTimeStyle = "%H\\n%M";
          NumWorkspaces = 5;
          AudioRevealer = true;
          LockCommand = "hyprlock";
          CPUThermalZone = "/sys/class/thermal/thermal_zone0/temp";
          GPUThermalZone = "/sys/class/drm/card1/device/hwmon/hwmon0/temp1_input";
      };
      extraConfig = ''
          WidgetsLeft: [Workspaces]
          WidgetsCenter: [Time]
          WidgetsRight: [Audio, Tray, GPU, CPU, RAM, Disk, Power]
          IconsAlwaysUp: true
          SensorTooltips: true
          DrmAmdCard: card1
      '';
      # This is only this long because I had to convert from scss to css
      extraCSS = ''
        * {
          all: unset;
          font-family: "JetBrainsMono Nerd Font";
        }
        .popup {
          color: #9ccfd8;
          background-color: #26233a;
        }

        .bar {
          margin: 8px 0 8px 4px;
          border: 1px solid #ebbcba;
        }

        .bar,
        tooltip {
          background-color: #1f1d2e;
          border-radius: 20px;
        }

        .right {
          border-radius: 20px;
        }

        .time-text {
          font-size: 18px;
        }

        .workspaces {
          margin-left: 5px;
        }
        .reboot-button {
          font-size: 28px;
          color: #908caa;
        }

        .sleep-button {
          font-size: 28px;
          color: #908caa;
        }

        .sni {
          margin-left: 8px;
        }

        .exit-button {
          font-size: 28px;
          color: #908caa;
        }

        .power-button {
          font-size: 28px;
          color: #eb6f92;
        }

        .system-confirm {
          color: #9ccfd8;
        }

        trough {
          border-radius: 3px;
          border-width: 1px;
          border-style: none;
          background-color: #524f67;
          min-width: 4px;
          min-height: 4px;
        }

        slider {
          border-radius: 0%;
          border-width: 1px;
          border-style: none;
          margin: -9px -9px -9px -9px;
          min-width: 16px;
          min-height: 16px;
          background-color: transparent;
        }

        highlight {
          border-radius: 3px;
          border-width: 1px;
          border-style: none;
          min-width: 6px;
          min-height: 6px;
        }

        .audio-icon {
          font-size: 24px;
          color: #ebbcba;
        }

        .audio-volume {
          padding-top: 0;
          font-size: 16px;
          color: #ebbcba;
        }
        .audio-volume trough {
          background-color: #524f67;
        }
        .audio-volume slider {
          background-color: transparent;
        }
        .audio-volume highlight {
          background-color: #ebbcba;
        }

        .mic-icon {
          font-size: 24px;
          color: #c4a7e7;
        }

        .mic-volume {
          font-size: 16px;
          color: #c4a7e7;
        }
        .mic-volume trough {
          background-color: #524f67;
        }
        .mic-volume slider {
          background-color: transparent;
        }
        .mic-volume highlight {
          background-color: #c4a7e7;
        }

        .package-outofdate {
          margin: -5px -5px -5px -5px;
          font-size: 24px;
          color: #eb6f92;
        }

        .bt-num {
          font-size: 18px;
          color: #31748f;
        }

        .bt-label-on {
          font-size: 20px;
          color: #31748f;
        }

        .bt-label-off {
          font-size: 24px;
          color: #31748f;
        }

        .bt-label-connected {
          font-size: 28px;
          color: #31748f;
        }

        .disk-util-progress {
          color: #c4a7e7;
          background-color: #524f67;
          font-size: 18px;
        }

        .disk-data-text {
          color: #c4a7e7;
          font-size: 18px;
        }

        .vram-util-progress {
          color: #ebbcba;
          background-color: #524f67;
        }

        .vram-data-text {
          color: #ebbcba;
          font-size: 18px;
        }

        .ram-util-progress {
          color: #f6c177;
          background-color: #524f67;
        }

        .ram-data-text {
          color: #f6c177;
          font-size: 18px;
        }

        .gpu-util-progress {
          color: #31748f;
          background-color: #524f67;
        }

        .gpu-data-text {
          color: #31748f;
          font-size: 18px;
        }

        .cpu-util-progress {
          color: #9ccfd8;
          background-color: #524f67;
          font-size: 18px;
        }

        .cpu-data-text {
          color: #9ccfd8;
          font-size: 18px;
        }

        .battery-util-progress {
          color: #ebbcba;
          background-color: #524f67;
          font-size: 18px;
        }

        .battery-data-text {
          color: #ebbcba;
          font-size: 18px;
        }

        .battery-charging {
          color: #ebbcba;
        }

        .network-data-text {
          color: #9ccfd8;
          font-size: 18px;
        }

        .network-up-under {
          color: #524f67;
        }

        .network-up-low {
          color: #9ccfd8;
        }

        .network-up-mid-low {
          color: #f6c177;
        }

        .network-up-mid-high {
          color: #ebbcba;
        }

        .network-up-high {
          color: #c4a7e7;
        }

        .network-up-over {
          color: #eb6f92;
        }

        .network-down-under {
          color: #524f67;
        }

        .network-down-low {
          color: #9ccfd8;
        }

        .network-down-mid-low {
          color: #f6c177;
        }

        .network-down-mid-high {
          color: #ebbcba;
        }

        .network-down-high {
          color: #c4a7e7;
        }

        .network-down-over {
          color: #eb6f92;
        }

        .ws-dead {
          color: #524f67;
          font-size: 18px;
        }

        .ws-inactive {
          color: #908caa;
          font-size: 18px;
        }

        .ws-visible {
          color: #31748f;
          font-size: 18px;
        }

        .ws-current {
          color: #f6c177;
          font-size: 18px;
        }

        .ws-active {
          color: #9ccfd8;
          font-size: 18px;
        }

        @keyframes connectanim {
          from {
            background-image: radial-gradient(circle farthest-side at center, #31748f 0%, transparent 0%, transparent 100%);
          }
          to {
            background-image: radial-gradient(circle farthest-side at center, #31748f 0%, #31748f 100%, transparent 100%);
          }
        }
        @keyframes disconnectanim {
          from {
            background-image: radial-gradient(circle farthest-side at center, transparent 0%, #31748f 0%, #31748f 100%);
          }
          to {
            background-image: radial-gradient(circle farthest-side at center, transparent 0%, transparent 100%, #31748f 100%);
          }
        }
        @keyframes scanonanim {
          from {
            color: #f6c177;
          }
          to {
            color: #9ccfd8;
          }
        }
        @keyframes scanoffanim {
          from {
            color: #9ccfd8;
          }
          to {
            color: #f6c177;
          }
        }
        .bt-bg {
          background-color: #1f1d2e;
          border-radius: 16px;
        }

        .bt-header-box {
          margin-top: 4px;
          margin-right: 8px;
          margin-left: 8px;
          font-size: 24px;
          color: #31748f;
        }

        .bt-body-box {
          margin-right: 8px;
          margin-left: 8px;
        }

        .bt-button {
          border-radius: 16px;
          padding-left: 8px;
          padding-right: 8px;
          padding-top: 4px;
          padding-bottom: 4px;
          margin-bottom: 4px;
          margin-top: 4px;
          font-size: 16px;
        }
        .bt-button.active {
          animation-name: connectanim;
          animation-duration: 50ms;
          animation-timing-function: linear;
          animation-fill-mode: forwards;
        }
        .bt-button.inactive {
          animation-name: disconnectanim;
          animation-duration: 50ms;
          animation-timing-function: linear;
          animation-fill-mode: forwards;
        }
        .bt-button.failed {
          color: #eb6f92;
        }

        .bt-close {
          color: #eb6f92;
          background-color: #524f67;
          border-radius: 16px;
          padding: 0px 8px 0px 7px;
          margin: 0px 0px 0px 8px;
        }

        .bt-scan {
          color: #f6c177;
          background-color: #524f67;
          border-radius: 16px;
          padding: 2px 11px 0px 7px;
          margin: 0px 0px 0px 10px;
          font-size: 18px;
        }
        .bt-scan.active {
          animation-name: scanonanim;
          animation-duration: 50ms;
          animation-timing-function: linear;
          animation-fill-mode: forwards;
        }
        .bt-scan.inactive {
          animation-name: scanoffanim;
          animation-duration: 50ms;
          animation-timing-function: linear;
          animation-fill-mode: forwards;
        }
      '';
    };
  };
}
