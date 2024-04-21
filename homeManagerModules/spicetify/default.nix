
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {

imports = [
    inputs.spicetify-nix.homeManagerModules.default 
];
  options = {
    spicetify.enable = lib.mkEnableOption "Enable spicetify";
  };

  config = let 
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
    hazyTheme = pkgs.fetchgit {
      url = "https://github.com/Astromations/Hazy";
      rev = "e157c45a6db066ff063e5071186a49c027377201";
      sha256 = "sha256-MTN6Yxe9wBErzFhrdApaQoR2vlxl6abW1nCyTkgjfUs=";
    };
  in lib.mkIf config.spicetify.enable {
    programs.spicetify = {
      enable = true;
      ## Use this image url: https://i.imgur.com/6XB9DJX.png ##
      sidebarConfig = true;
      theme = {
        name = "Hazy";
        src = hazyTheme;
        requiredExtensions = [
        {
          filename = "theme.js";
          src = "${hazyTheme}";
        }
        {
          filename = "user.css";
          src = "${hazyTheme}";
        }
        {
          filename = "color.ini";
          src = "${hazyTheme}";
        }
        ];
        appendName = false; 
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
      };
        enabledExtensions = with spicePkgs.extensions; [
          hidePodcasts
          shuffle
          adblock
          playlistIcons
          historyShortcut
          bookmark
          fullAlbumDate
          keyboardShortcut
          history
          songStats
          powerBar
          wikify
          copyToClipboard    
        ];
      };
    };
}
