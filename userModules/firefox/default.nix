{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  options = {
    modules.user.firefox.enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf config.modules.user.firefox.enable {

    # To use the unfree predicate this needs to be added as an overlay
    # https://discourse.nixos.org/t/allow-unfree-packages-in-repo-from-nur/41732/2
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [keepassxc-browser vimium wayback-machine  youtube-shorts-block];
          settings = {
            "extensions.autoDisableScopes" = 0;
          };
        };
      };
    };
  };
}
