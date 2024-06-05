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
        colors.draw_bold_text_with_bright_colors = true;
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
        window.opacity = 0.50;
        window.padding.x = 5;
        window.padding.y = 5;
        scrolling.history = 5000;
      };
    };
  };
}
