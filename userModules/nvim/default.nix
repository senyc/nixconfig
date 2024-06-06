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
        rubyfmt
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
        telescope-nvim
        vim-illuminate
        zen-mode-nvim
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          p.bash
          p.c
          p.embedded_template
          p.cpp
          p.css
          p.csv
          p.git_config
          p.git_rebase
          p.gitattributes
          p.gitcommit
          p.gitignore
          p.go
          p.helm
          p.html
          p.javascript
          p.json
          p.lua
          p.luadoc
          p.make
          p.nix
          p.python
          p.ruby
          p.toml
          p.tsx
          p.typescript
          p.vim
          p.vimdoc
          p.yaml
        ]))
      ];
    };
    # Link all of the lua config
    xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
    };
  };
}
