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
      };
    };
  };
}
