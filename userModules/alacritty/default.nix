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
          size = 12;
        };
        window.opacity = 0.50;
        window.padding.x = 5;
        window.padding.y = 5;
        scrolling.history = 5000;
      };
    };
  };
}
