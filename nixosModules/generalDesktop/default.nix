{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    generalDesktop.enable = mkEnableOption "Enable general defaults (fonts, locales, boot)";

    generalDesktop.hasAmdCard = lib.mkEnableOption "enable amd card pre-loading";
    config = mkIf config.generalDesktop.enable {
      sound.enable = true;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        # For screen sharing
        wireplumber.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
      fonts.packages = with pkgs; [
        (nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka" "FiraCode"];})
      ];

      fonts.enableDefaultPackages = true;
      fonts.fontconfig = {
        defaultFonts = {
          monospace = ["JetBrainsMono Nerd Font Mono"];
          sansSerif = ["JetBrainsMono Nerd Font"];
          serif = ["JetBrainsMono Nerd Font"];
        };
      };
      time.timeZone = "America/New_York";
      i18n.defaultLocale = "en_US.UTF-8";
      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        initrd = lib.mkIf config.boot.hasAmdCard {
          kernelModules = ["amdgpu"];
        };
      };
    };
  };
}
