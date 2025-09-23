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
    allowedUnfree = ["postman" "ngrok"];

    home.packages = with pkgs; [
      # terraform
      act
      ngrok
      postman
      bun
      gimp
      doctl
      fzf
      jq
      dig
      hyprpicker
      kubectl
      stripe-cli
      kubernetes-helm
      linode-cli
      sqlite
      stern
      yarn
      yq
    ];
  };
}
