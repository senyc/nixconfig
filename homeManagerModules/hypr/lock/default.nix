{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprlock.homeManagerModules.default 
  ];

  options = {
    hyprlock.enable = lib.mkEnableOption "Enable hyprlock";
  };

  config = lib.mkIf config.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      general = {
        grace = 0;
        no_fade_in = false;
      };
      backgrounds = [
        {
          monitor = "DP-2";
          path = "${ ../../../backgrounds/primary_background.png }";
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];
      input-fields = [
        {
          monitor = "DP-2";
          size = {
            width = 290;
            height = 65;
          };
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8;
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          placeholder_text = ''<i><span foreground="##ffffffb3">Password...</span></i>'';
          inner_color = "rgba(0, 0, 0, 0.5)";
          font_color = "rgba(255, 255, 255, .7)";
          fade_on_empty = false;
          hide_input = false;
          position.x = 0;
          position.y = -120;
        }
      ];
      labels = [
        {
          monitor = "DP-2";
          text = ''cmd[update:1000] echo "$(date +"%R")"'';
          color = "rgba(255, 255, 255, .7)";
          font_size = 135;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position.x = 0;
          position.y = -300;
          valign = "top";
          halign = "center";
        }
        {
          monitor = "DP-2";
          text = "Hi there, $USER";
          color = "rgba(255, 255, 255, .7)";
          font_size = 25;
          font_family = "JetBrains Mono Nerd Font Mono";
          position.x = 0;
          position.y = -40;
        }
        {
          monitor = "DP-2";
          text = ''cmd[update:1000] echo "$(playerctl metadata --format '{{title}}  {{artist}}')"'';
          color = "rgba(255, 255, 255, .7)";
          font_size = 18;
          font_family = "JetBrainsMono, Font Awesome 6 Free Solid";
          position.x = 0;
          position.y = -15;
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
