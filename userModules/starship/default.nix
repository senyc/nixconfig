{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.starship.enable = lib.mkEnableOption "Enable starship";
  };

  config = lib.mkIf config.modules.user.starship.enable {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        line_break = {
          disabled = true;
        };
        git_status = {
          renamed = ''[R''${count}](orange) '';
          deleted = ''[D''${count}](red) '';
          ahead = ''󰁝 ''${count} '';
          behind = ''󰁅 ''${count} '';
          diverged = ''󰁝''${ahead_count} 󰁅''${behind_count} '';
          untracked = ''[U''${count}](yellow) '';
          stashed = ''[](blue) '';
          modified = ''[M''${count}](#FFA500) '';
          staged = ''[S''${count}](green) '';
          style = ''bright-white'';
          format = ''$all_status$ahead_behind'';
        };
        directory = {
          truncation_length = 5;
          home_symbol = "~";
          format = "[$path]($style)[$lock_symbol]($lock_style) ";
        };
        character = {
          success_symbol = ''[\$](white)'';
          error_symbol = ''[\$](white)'';
        };
        package = {
          disabled = true;
        };
        aws = {
          disabled = true;
        };
        username = {
          style_user = "bold green";
          show_always = true;
        };
        cmd_duration = {
          min_time = 10000;
        };
      };
    };
  };
}
