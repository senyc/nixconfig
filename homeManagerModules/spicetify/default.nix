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
  in
    lib.mkIf config.spicetify.enable {
      programs.spicetify = {
        enable = true;
        injectCss = true;
        replaceColors = true;
        overwriteAssets = true;
        sidebarConfig = true;
        theme = spicePkgs.themes.Sleek;
        colorScheme = "RosePine";
        enabledExtensions = with spicePkgs.extensions; [
          hidePodcasts
          shuffle
          seekSong
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
