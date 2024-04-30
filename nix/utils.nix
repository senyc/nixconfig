{
  inputs,
  outputs,
  ...
}: let
  generateImports = dir: modules:
    map (module: ../${dir}/${module}) modules;
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

  generateNixosImports = modules:
    generateImports "nixosModules" modules;

  generateHomeManagerImports = modules:
    generateImports "homeManagerModules" modules;
}
