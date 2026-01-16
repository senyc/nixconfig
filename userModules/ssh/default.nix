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
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = [
            # "~/.ssh/id_ecdsa_sk"
            "~/.ssh/id_ed25519_sk"
          ];
        };
        "*" = {
          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
      extraConfig = ''
        Include ~/.ssh/extra_config
      '';
    };
  };
}
