{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    modules.system.excalidraw.enable = mkEnableOption "Enable excalidraw server";
  };

  config = mkIf config.modules.system.excalidraw.enable {
    virtualisation.docker = {
      enable = true;
    };
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        excalidraw = {
          image = "excalidraw/excalidraw";
          ports = ["4321:80"];
        };
      };
    };
  };
}
