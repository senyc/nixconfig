{
  config,
  lib,
  ...
}: {
  options = {
    modules.user.ssh.enable = lib.mkEnableOption "Enable ssh configuration";
  };
  config = lib.mkIf config.modules.user.ssh.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        testenv = {
          hostname = "104.131.127.239";
          identityFile = ["~/.ssh/id_personal"];
          user = "qa";
        };
        "github.com-personal" = {
          hostname = "github.com";
          user = "git";
          identityFile = [
            "~/.ssh/id_ed25519_sk"
            "~/.ssh/id_ecdsa_sk"
            "~/.ssh/id_personal"
          ];
        };
        "github.com-work" = {
          hostname = "github.com";
          user = "git";
          identityFile = [
            "~/.ssh/id_work_sk"
            "~/.ssh/id_work_two_sk"
          ];
        };
      };
    };
  };
}
