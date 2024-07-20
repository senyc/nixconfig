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
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        cursor_shape = "block";
        cursor_blink_interval = 0;
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        force_ltr = "no";
        disable_ligatures = "always";
        window_padding_width = 3;
        tab_title_max_length = 50;
        tab_bar_edge = "top";
        enabled_layouts = "Tall,Fat,Grid";
        # Don't ever phone home for updates
        update_check_interval = 0;
      };
      keybindings = {
        # open new tab and os window with the current directory
        "ctrl+shift+t" = "launch --cwd=current --type=tab";
        "ctrl+shift+n" = "launch --cwd=current --type=os-window";

        "super+w" = "launch --cwd=current";
        "super+g" = ''send_text normal,application getprojects\n'';

        "ctrl+f2" = "detach_window";
        "ctrl+f3" = "detach_window new-tab";
        # fixes gesc keybind
        "super+`" = "send_key `";
      };
      shellIntegration = {
        enableZshIntegration = true;
        mode = "no-cursor";
      };
    };
  };
}
