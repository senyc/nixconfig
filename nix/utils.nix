{
  inputs,
  outputs,
  ...
}: let
  generateImports = moduleType: modules:
    map (module: ../${moduleType}Modules/${module}) modules;

  useModules = let
    f = modules:
      with builtins;
        if modules != []
        then
          {
            ${head modules}.enable = true;
          }
          // f (tail modules)
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
    // {modules.${moduleType} = useModules modules;};
in {
  addSystemModules = addModulesTo "system";
  addUserModules = addModulesTo "user";

  mkHosts = let
    mkHost = dev: {
      ${dev} = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ../hosts/${dev}
        ];
      };
    };
    f = with builtins;
      devices:
        if devices != []
        then mkHost (head devices) // f (tail devices)
        else {};
  in
    f;
}
