{
  lib,
  config,
  ...
}:
with lib; {
  options = {
    homeImpermanence.enable = mkEnableOption "Default user impermance setup";
  };
  config = mkIf config.homeImpermanence.enable {
    home.persistence."/persist/home/senyc" = {
      directories = [
        "Downloads"
        "projects"
        "work"
        "nixconfig"
        ".ssh"
        # nvim extensions
        ".local/share/nvim"
        # Brave extensions
        ".config/BraveSoftware/Brave-Browser/Default/Extensions"
        ".config/BraveSoftware/Brave-Browser/Default/'Extension State'"
        ".config/BraveSoftware/Brave-Browser/Default/'Extension Scripts'"
        ".config/BraveSoftware/Brave-Browser/Default/'Extension Rules'"
      ];
      files = [
        ".config/sops/age/keys.txt"
        # Brave preferences and cookies (to stay logged in to sites)
        ".config/BraveSoftware/Brave-Browser/Default/Cookies"
        ".config/BraveSoftware/Brave-Browser/Default/Preferences"
        ".config/keepassxc/keepassxc.ini"
      ];
      allowOther = true;
    };
  };
}
