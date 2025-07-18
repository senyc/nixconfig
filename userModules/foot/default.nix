{
  lib,
  config,
  ...
}: {
  options = {
    modules.user.foot.enable = lib.mkEnableOption "Enable foot";
  };
  config = lib.mkIf config.modules.user.foot.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font Mono:size=15";
        };
        cursor = {
          color = "11111b f5e0dc";
        };

        colors = {
          foreground = "cdd6f4";
          background = "1e1e2e";

          # Regular colors
          regular0 = "45475a";
          regular1 = "f38ba8";
          regular2 = "a6e3a1";
          regular3 = "f9e2af";
          regular4 = "89b4fa";
          regular5 = "f5c2e7";
          regular6 = "94e2d5";
          regular7 = "bac2de";

          # Bright colors
          bright0 = "585b70";
          bright1 = "f38ba8";
          bright2 = "a6e3a1";
          bright3 = "f9e2af";
          bright4 = "89b4fa";
          bright5 = "f5c2e7";
          bright6 = "94e2d5";
          bright7 = "a6adc8";

          # Extended colors
          "16" = "fab387";
          "17" = "f5e0dc";

          # Additional colors
          selection-foreground = "cdd6f4";
          selection-background = "414356";

          search-box-no-match = "11111b f38ba8";
          search-box-match = "cdd6f4 313244";

          jump-labels = "11111b fab387";
          urls = "89b4fa";
        };
      };
    };
  };
}
