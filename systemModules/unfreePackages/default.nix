{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    modules.system.unfreePackages.enable = mkEnableOption "Enable unfree system packages";
    allowedUnfree = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
  config.nixpkgs.config.allowUnfreePredicate = p: elem (getName p) config.allowedUnfree;
}
