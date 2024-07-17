{
  config,
  lib,
  ...
}: {
  options = {
    modules.system.steam.enable = lib.mkEnableOption "Enable steam";
  };
  config = lib.mkIf config.modules.system.steam.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      lib.elem (lib.getName pkg) [
        "steam-original"
        "steam"
        "steam-run"
      ];
    programs.steam = {
      enable = true;
    };
  };
}
