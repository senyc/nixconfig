{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    modules.user.unfreePackages.enable = mkEnableOption "Enable unfree home packages";
    allowedUnfree = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
  config.nixpkgs.config.allowUnfreePredicate = p: elem (getName p) config.allowedUnfree;
}
