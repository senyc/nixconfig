{
  inputs,
  outputs,
  pkgs,
}: {
  mkHost = dev: {
    ${dev} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        ../hosts/${dev}
      ];
    };
  };
}
