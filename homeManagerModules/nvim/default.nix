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
    # Link all of the lua config
    xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
    };

    # Lanuage servers and formatters
    home.packages = with pkgs; [
      clang-tools # Clangd
      alejandra 
      lua-language-server
      nodePackages.typescript-language-server
      nil
      gopls
      tailwindcss-language-server
      nodePackages.bash-language-server
    ];
  };
}
