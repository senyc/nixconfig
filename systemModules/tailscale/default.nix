{
  config,
  lib,
  ...
}: {
  options = {
    modules.system.tailscale.enable = lib.mkEnableOption "Enable tailscale service";
  };

  config = lib.mkIf config.modules.system.tailscale.enable {
    services.tailscale = {
      enable = true;
      # This defers dns from my home router which I don't want
      # To support magic dns I manually add the node names -> ip addresses in
      # the network module
      extraSetFlags = [
        "--accept-dns=false"
      ];
    };
  };
}
