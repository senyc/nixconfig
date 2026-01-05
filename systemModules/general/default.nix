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
        systemd-boot.editor = false;
      };
      initrd.luks.devices.cryptroot = {
        device = "/dev/disk/by-label/cryptroot";
      };
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "tmpenroll" ''
        sudo systemd-cryptenroll \
          --tpm2-device=auto \
          --tpm2-pcrs=0+2+4+7 \
          /dev/disk/by-label/cryptroot
      '')
    ];

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
      openssh = {
        extraConfig = ''
          AllowAgentForwarding yes
        '';
        enable = true;
      };
    };

    environment.sessionVariables = {
      XCURSOR_SIZE = 16;
    };
  };
}
