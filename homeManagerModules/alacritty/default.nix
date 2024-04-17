{
  pkgs,
  config,
  lib,
  ...
}: {

options = {
  alacritty.enable = lib.mkEnableOption "Enable alacritty";
  };
  config = lib.mkIf config.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        colors.draw_bold_text_with_bright_colors = true;
        font = {
          size = 12;
        };
        window.opacity = 0.65;
        window.padding.x = 13;
        window.padding.y = 13;
        scrolling.history = 5000;
      };
    };
  };
}
