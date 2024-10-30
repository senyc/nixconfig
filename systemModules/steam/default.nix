{
  config,
  lib,
  ...
}: {
  options = {
    modules.system.steam.enable = lib.mkEnableOption "Enable steam";
  };
  config = lib.mkIf config.modules.system.steam.enable {
    allowedUnfree = [
      "steam-original"
      "steam"
      "steam-run"
      "steam-unwrapped"
    ];
    programs.steam = {
      enable = true;
    };
  };
}
