{inputs}: {
  addPackages = final: prev: {
    myPackages = {
      kx = inputs.kx.packages."x86_64-linux".default;
    };
  };
}
