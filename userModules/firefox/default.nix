{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    modules.user.firefox.enable = lib.mkEnableOption "Enable firefox";
  };
  config = lib.mkIf config.modules.user.firefox.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            keepassxc-browser
            vimium
          ];
          settings = {
            # Allows for the above added extensions to be enabled
            "extensions.autoDisableScopes" = 0;
            # Simplifies new tab page
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showWeather" = false;

            "browser.aboutwelcome.didSeeFinalScreen" = true;
            "app.normandy.first_run" = false;
            "trailhead.firstrun.didSeeAboutWelcome" = true;
          };
        };
      };
    };
  };
}
