{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.chromium.enable = lib.mkEnableOption "Enable chromium and associated extension";
  };
  config = lib.mkIf config.modules.user.chromium.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        {
          id = "dbepggeogbaibhgnhhndojpepiihcmeb";
        }
        {
          id = "gighmmpiobklfepjocnamgkkbiglidom";
        }
        {
          id = "oboonakemofpalcgghocfoadofidjkkk";
        }
        {
          id = "aljlkinhomaaahfdojalfmimeidofpih";
        }
      ];
    };
  };
}
