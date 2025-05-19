{
  lib,
  config,
  ...
}: {
  options = {
    modules.system.gnome.enable = lib.mkEnableOption "Enable gnome configuration";
  };

  config = lib.mkIf config.modules.system.gnome.enable {
    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = true;
          settings = {
            "org/gnome/desktop/interface" = {
              overlay-scrolling = false;
            };
            "org/ghome/desktop/peripherals/mouse" = {
              accel-profile = "flat";
              natural-scroll = false;
            };
            "org/ghome/desktop/peripherals/touchpad" = {
              two-fonger-scrolling-enabled = true;
            };
            "org/gnome/desktop/wm/keybindings" = {
              switch-to-workspace-1 = ["<Super>e"];
              switch-to-workspace-2 = ["<Super>t"];
              switch-to-workspace-3 = ["<Super>r"];
              switch-to-workspace-4 = ["<Super>o"];
              switch-to-workspace-5 = ["<Super>m"];
              toggle-maximized = ["<Super>f"];
              cycle-windows = ["<Super>h"];
              cycle-windows-backward = ["<Super>l"];
              panel-run-dialog = ["<Super>semicolon"];
              minimize = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              close = ["<Super>x"];
            };
            "org/gnome/mutter" = {
              edge-tiling = true;
            };
            "org/gnome/mutter/keybindings" = {
              toggle-tiled-left = ["<Shift><Super>h"];
              toggle-tiled-right = ["<Shift><Super>l"];
            };

            "org/gnome/settings-daemon/plugins/media-keys" = {
              screensaver = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
              ];
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              binding = "<Super>q";
              command = "alacritty";
              name = "Open terminal";
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
              binding = "<Super>b";
              command = "firefox";
              name = "Open browser";
            };
          };
        }
      ];
    };
  };
}
