{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.user.dev.enable = lib.mkEnableOption "Enable developer packages";
  };
  config = lib.mkIf config.modules.user.dev.enable {
    allowedUnfree = ["terraform"];

    home.packages = with pkgs; [
      act
      doctl
      jq
      kubectl
      kubernetes-helm
      terraform
      linode-cli
      yq
      fzf
      yarn
      sqlite
      bun
      stern
    ];
  };
}
