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
      extraPackages = with pkgs; [
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
      plugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-path
        comment-nvim
        gitsigns-nvim
        luasnip
        nvim-cmp
        nvim-lspconfig
        nvim-surround
        nvim-treesitter
        telescope-nvim
        vim-illuminate
        zen-mode-nvim
      ];
    };
    # Link all of the lua config
    xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
    };
  };
}