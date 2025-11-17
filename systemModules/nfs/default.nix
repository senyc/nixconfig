{
  config,
  lib,
  ...
}: {
  options = {
    modules.system.nfs.enable = lib.mkEnableOption "Enable NFS client support";
  };
  config = lib.mkIf config.modules.system.nfs.enable {
    # Enable NFS client support
    services.nfs.server.enable = true;

    # Ensure NFS utilities are available
    boot.supportedFilesystems = ["nfs"];

    # Create the mount point directory
    systemd.tmpfiles.rules = [
      "d /home/senyc/ob/data 0755 senyc users -"
    ];

    fileSystems."/home/senyc/ob/data" = {
      device = "vault:/home/senyc/data";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
        "_netdev"
        "soft"
        "timeo=5"
        "retrans=1"
        "x-systemd.device-timeout=5s"
        "x-systemd.requires=network-online.target"
        # Required otherwise reboot/shutdown will hang since tailscale is shutdown before it tries to unmount
        "x-systemd.requires=tailscaled.service"
        # Wait for tailscale to be fully online before attempting mount
        "x-systemd.after=tailscaled.service"
      ];
    };
  };
}
