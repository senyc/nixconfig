{inputs}: {
  default = final: prev: {
    myPackages = {
      kx = inputs.kx.packages."x86_64-linux".default;
      xdg-desktop-portal-hyprland = inputs.xdg-desktop-portal-hyprland.packages."x86_64-linux".default;
    };
  };
}
