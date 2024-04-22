{ 
  config, 
  lib, 
  pkgs, 
  inputs,
  ... 
}: {
  imports = [ # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ./greetd
  ];

  # Nix configurations 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  greeter.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # AMD drivers
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Fonts/TZ/Locales
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Allow certain unfree packages

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" "FiraCode" ]; })
  ];

  # This is a requirement for various gtk related services
  programs.dconf.enable = true; 

  fonts.enableDefaultPackages = true;
  fonts.fontconfig = {
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font Mono"];
      sansSerif = ["JetBrainsMono Nerd Font"];
      serif = ["JetBrainsMono Nerd Font"];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Required to add nix related functionality to path?
  programs.zsh.enable = true;

  users.mutableUsers = false;
  users.users.senyc = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/senyc";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" "docker"];
    initialPassword = "password";
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "senyc" = import ../homeManagerModules/home.nix;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    zip
    unzip
    which
    ripgrep
    jq
    lua
    python3
    go
    luarocks
    nodejs
    rustc
    cargo
    lm_sensors # run sudo sensors-detect initially then sensors to get results
    docker-compose
   ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  networking.hosts = {
    "127.0.0.1" = [ "https://youtube.com" "https://www.youtube.com" ];
  };

  # Hopefully fix issues with wayland and cursors
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    QT_SCALE_FACTOR=1;
    ELM_SCALE=1;
    GDK_SCALE=1;
    XCURSOR_SIZE=16;
  };

  hardware = {
    opengl.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.11"; # Don't delete this
}
