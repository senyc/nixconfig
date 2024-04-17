{ 
  config, 
  lib, 
  pkgs, 
  inputs, 
  ... 
}: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Nix configurations 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" "DroidSansMono" ]; })
    corefonts
  ];

  nixpkgs.config.allowUnfree = true;
  fonts.enableDefaultPackages = true;
  fonts.fontconfig = {
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font Mono"];
      sansSerif = ["JetBrainsMono Nerd Font"];
      serif = ["JetBrainsMono Nerd Font"];
    };
  };

  # Required to add nix related functionality to path?
  programs.zsh.enable = true;

  users.mutableUsers = false;
  users.users.senyc = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/senyc";
    createHome = true;
    extraGroups = [ "wheel" "networkmanager"];
    initialPassword = "password";
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "senyc" = import ./home.nix;
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
   ];

  environment.shellAliases = {
    t = "tmux";
  };

   # services.displayManager.sddm.enable = true;
   # services.displayManager.sddm.wayland.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Don't delete this
}
