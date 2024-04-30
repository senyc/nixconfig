{
  inputs,
  outputs,
  ...
}: let
  utils = import ./utils.nix {inherit inputs outputs;};
in {
  mkHost = dev: {
    ${dev} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        ../hosts/${dev}
      ];
    };
  };

  useModules = let
    f = modules:
      with builtins;
        if modules != []
        then {${(head modules)} = {enable = true;};} // (f (tail modules))
        else {};
  in
    f;

  generateImports = dir: modules:
    map (module: ../${dir}/${module}) modules;

  generateNixosImports = modules:
    utils.generateImports "nixosModules" modules;

  generateHomeManagerImports = modules:
    utils.generateImports "homeManagerModules" modules;
}
