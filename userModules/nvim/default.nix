{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.user.nvim.enable = lib.mkEnableOption "Enable nvim";
  };
  config = lib.mkIf config.modules.user.nvim.enable {
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
      yaml-language-server
      alejandra
      lua-language-server
      nodePackages.typescript-language-server
      nodePackages.pyright
      nil
      gopls
      tailwindcss-language-server
      nodePackages.bash-language-server
    ];
  };
}
