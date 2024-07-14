{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.kitty.enable = lib.mkEnableOption "Enable kitty";
  };
  config = lib.mkIf config.modules.user.kitty.enable {
    programs.kitty = {
      enable = true;
      theme = "Catppuccin-Macchiato";
      font = {
        name = "JetBrainsMono Nerd Font Mono";
        size = 13;
      };
      environment = {
        "TERM" = "xterm-256color";
      };
      settings = {
        shell = "zsh";
        scrollback_lines = 10000;
        enable_audio_bell = false;
        cursor_shape = "block";
        cursor_blink_interval = 0;
        tab_bar_style = "slant";
        force_ltr = "no";
        disable_ligatures = "always";
      };
      shellIntegration = {
        enableZshIntegration = true;
        mode = "no-cursor";
      };
    };
  };
}
