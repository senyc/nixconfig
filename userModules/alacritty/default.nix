{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.alacritty.enable = lib.mkEnableOption "Enable alacritty";
  };
  config = lib.mkIf config.modules.user.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        font = {
          size = 13;
          bold = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Bold";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Bold Italic";
          };
          italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Italic";
          };
          normal = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Regular";
          };
        };
        window = {
          opacity = 1;
          padding.x = 3;
          padding.y = 3;
        };

        scrolling = {
          history = 50000;
        };

        keyboard = {
          bindings = [
            # Set <C-B> to toggle vim mode
            {
              key = "B";
              mods = "Control";
              action = "ToggleViMode";
            }
            # On append enter "insert" mode
            {
              key = "A";
              mode = "Vi|~Search";
              action = "ToggleViMode";
            }
          ];
        };
        colors = {
          primary = {
            background = "#24273a";
            foreground = "#cad3f5";
            dim_foreground = "#8087a2";
            bright_foreground = "#cad3f5";
          };
          cursor = {
            text = "#24273a";
            cursor = "#f4dbd6";
          };
          vi_mode_cursor = {
            text = "#24273a";
            cursor = "#b7bdf8";
          };
          search = {
            matches = {
              foreground = "#24273a";
              background = "#a5adcb";
            };
            focused_match = {
              foreground = "#24273a";
              background = "#a6da95";
            };
          };
          footer_bar = {
            foreground = "#24273a";
            background = "#a5adcb";
          };
          hints = {
            start = {
              foreground = "#24273a";
              background = "#eed49f";
            };
            end = {
              foreground = "#24273a";
              background = "#a5adcb";
            };
          };
          selection = {
            text = "#24273a";
            background = "#f4dbd6";
          };
          normal = {
            black = "#494d64";
            red = "#ed8796";
            green = "#a6da95";
            yellow = "#eed49f";
            blue = "#8aadf4";
            magenta = "#f5bde6";
            cyan = "#8bd5ca";
            white = "#b8c0e0";
          };
          bright = {
            black = "#5b6078";
            red = "#ed8796";
            green = "#a6da95";
            yellow = "#eed49f";
            blue = "#8aadf4";
            magenta = "#f5bde6";
            cyan = "#8bd5ca";
            white = "#a5adcb";
          };
          dim = {
            black = "#494d64";
            red = "#ed8796";
            green = "#a6da95";
            yellow = "#eed49f";
            blue = "#8aadf4";
            magenta = "#f5bde6";
            cyan = "#8bd5ca";
            white = "#b8c0e0";
          };
          indexed_colors = [
            {
              index = 16;
              color = "#f5a97f";
            }
            {
              index = 17;
              color = "#f4dbd6";
            }
          ];
        };
      };
    };
  };
}
