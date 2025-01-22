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
    # you can copy the permissions.sqllite file into .mozilla which when encoded will save our cookies
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
            "places.history.enabled" = false;
            "privacy.fingerprintingProtection" = true;
            "privacy.bounceTrackingProtection.hasMigratedUserActivationData" = false;
            "privacy.clearOnShutdown_v2.siteSettings" = true;
            "privacy.trackingprotection.emailtracking.enabled" = true;
            "privacy.sanitize.sanitizeOnShutdown" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "browser.contentblocking.category" = "strict";
          };
        };
      };
    };
    # Values in this file can be edited with the addcookieexception script
    #  This will preserve certain cookies between browser restart
    home.file = {
      ".mozilla/firefox/default/permissions.sqlite" = {
        source = ./permissions.sqlite;
      };
    };
  };
}
