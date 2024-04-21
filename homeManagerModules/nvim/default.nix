{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    nvim.enable = lib.mkEnableOption "Enable nvim";
  };
  config = lib.mkIf config.tmux.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
    xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
    };
  };
}
