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
    # allowedUnfree = ["terraform"];

    home.packages = with pkgs; [
      # terraform
      act
      bun
      doctl
      fzf
      jq
      kubectl
      kubernetes-helm
      linode-cli
      sqlite
      stern
      yarn
      yq
    ];
  };
}
