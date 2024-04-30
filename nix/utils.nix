{
  inputs,
  outputs,
  ...
}: let
  generateImports = dir: modules:
    map (module: ../${dir}/${module}) modules;

  useModules = let
    f = modules:
      with builtins;
        if modules != []
        then {${head modules} = {enable = true;};} // f (tail modules)
        else {};
  in
    f;

  addModulesTo = moduleType: modules: config: let
    importList = generateImports moduleType modules;
  in
    config
    // {
      imports =
        if config ? "imports"
        then importList ++ config.imports
        else importList;
    }
    // useModules modules;
in {
  addNixosModules = addModulesTo "nixosModules";
  addHomeManagerModules = addModulesTo "homeManagerModules";

  mkHost = dev: {
    ${dev} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        ../hosts/${dev}
      ];
    };
  };
}
