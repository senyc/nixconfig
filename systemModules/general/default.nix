{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options = {
    modules.system.general.enable = mkEnableOption "Enable general defaults (fonts, locales, boot)";
  };

  config = mkIf config.modules.system.general.enable {
    nix.settings.experimental-features = ["nix-command" "flakes"];

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    security.rtkit.enable = true;

    fonts = {
      packages = with pkgs; [
        # (nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka" "FiraCode"];})
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
        nerd-fonts.fira-code
      ];
      enableDefaultPackages = true;
      fontconfig = {
        defaultFonts = {
          monospace = ["JetBrainsMono Nerd Font Mono"];
          sansSerif = ["JetBrainsMono Nerd Font"];
          serif = ["JetBrainsMono Nerd Font"];
        };
      };
    };

    hardware = {
      graphics.enable = true;
    };

    services = {
      blueman.enable = true;
      printing.enable = true;
      openssh.enable = true;
    };

    environment.sessionVariables = {
      XCURSOR_SIZE = 16;
    };
  };
}
