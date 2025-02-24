{
  inputs,
  outputs,
}: {
  addPackages = final: prev: {
    senyc-nvimconfig = inputs.neovim-config.packages.x86_64-linux.default;
    kx = inputs.kx.packages."x86_64-linux".default;
    # Used for firefox extensions
    nur = inputs.nur.legacyPackages.x86_64-linux;
    flameshotGrim = prev.flameshot.overrideAttrs (previousAttrs: {
      cmakeFlags = [
        "-DUSE_WAYLAND_CLIPBOARD=1"
        "-DUSE_WAYLAND_GRIM=1"
      ];
      buildInputs = previousAttrs.buildInputs ++ [final.libsForQt5.kguiaddons];
    });
  };
}
