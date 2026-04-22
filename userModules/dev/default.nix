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
    allowedUnfree = ["postman" "claude-code" "ngrok" "idea"];

    home.packages = with pkgs; [
      # terraform
      act
      ngrok
      postman
      bun
      gimp
      jetbrains.idea
      doctl
      caddy
      inkscape
      nmap
      claude-code
      fzf
      jq
      dig
      hyprpicker
      qpdf
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
