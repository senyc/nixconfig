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
        general.import = [./catppuccin-mocha.toml];
        env.TERM = "xterm-256color";
        font = {
          offset = {
            x = 0;
            y = 0;
          };
          size = 14;
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
          padding.y = 0;
          padding.x = 0;
          decorations = "None";
        };

        scrolling = {
          history = 50000;
        };

        keyboard = {
          bindings = [
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
