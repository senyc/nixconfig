{
  config,
  lib,
  ...
}: {
  options = {
    modules.system.pipewire.enable = lib.mkEnableOption "Enable pipewire configuration";
  };
  config = lib.mkIf config.modules.system.pipewire.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
