{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    modules.user.hyprlock.enable = lib.mkEnableOption "Enable hyprlock";
  };

  config = with pkgs; let
    getsong = writeShellScript "getsong.sh" ''
      ${playerctl}/bin/playerctl metadata --format "{{title}}  {{artist}}"
    '';

    getnotifcation = writeShellScript "getnotifcation.sh" ''
      output=$(${mako}/bin/makoctl list)
      app_names=$(echo "$output" | grep -oP "(?<=App name: ).*" | tr "\n" ", " | sed "s/,$//")
      if [[ -n $app_names ]]; then
        echo "󰂚<span color='red'><sup></sup></span> $app_names"
      else
        echo "󰂚 No new notifications"
      fi
    '';
  in
    lib.mkIf config.modules.user.hyprlock.enable {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            grace = 0;
          };
          background = [
            {
              path = "${../../backgrounds/winter_bridge.jpg}";
              blur_passes = 1;
            }
          ];
          input-field = [
            {
              size = "290, 65";
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
              position = "0, -120";
            }
          ];
          label = [
            {
              monitor = "";
              text = ''cmd[update:1000] echo "$(date +"%R")"'';
              color = "rgba(255, 255, 255, .7)";
              font_size = 135;
              font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
              position = "0, -300";
              valign = "top";
              halign = "center";
            }
            {
              text = "Hi there, $USER";
              monitor = "";
              color = "rgba(255, 255, 255, .7)";
              font_size = 25;
              font_family = "JetBrains Mono Nerd Font Mono";
              position = "0, -25";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "";
              text = ''cmd[update:1000] echo $(${getnotifcation})'';
              color = "rgba(255, 255, 255, .7)";
              font_size = 14;
              font_family = "JetBrainsMono, Font Awesome 6 Free Solid";
              position = "0, 530";
              halign = "center";
              valign = "bottom";
            }
            {
              monitor = "";
              text = ''cmd[update:1000] echo $(${getsong})'';
              color = "rgba(255, 255, 255, .7)";
              font_size = 18;
              font_family = "JetBrainsMono, Font Awesome 6 Free Solid";
              position = "0, 5";
              halign = "center";
              valign = "bottom";
            }
          ];
        };
      };
    };
}
