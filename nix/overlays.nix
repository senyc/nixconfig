{
  inputs,
  outputs,
}: {
  addPackages = final: prev: {
    senyc-nvimconfig = inputs.neovim-config.packages.x86_64-linux.default;
    kx = inputs.kx.packages."x86_64-linux".default;
    # Used for firefox extensions
    nur = inputs.nur.legacyPackages.x86_64-linux;
  };
}
