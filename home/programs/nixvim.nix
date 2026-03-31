# home/programs/nixvim.nix
{ config, pkgs, lib, ... }:
let
  theme = config.horizon.theme;
in {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    extraConfigLua = if theme.ui.nixvim_transparent then ''
      vim.cmd [[highlight Normal guifg=#${theme.colors.fg} guibg=NONE ctermbg=NONE]]
      vim.cmd [[highlight NormalNC guifg=#${theme.colors.fg} guibg=NONE ctermbg=NONE]]
      vim.cmd [[highlight EndOfBuffer guifg=#${theme.colors.fg} guibg=NONE ctermbg=NONE]]
    '' else ''
      vim.cmd [[highlight Normal guifg=#${theme.colors.fg} guibg=#${theme.colors.bg}]]
      vim.cmd [[highlight NormalNC guifg=#${theme.colors.fg} guibg=#${theme.colors.bg}]]
      vim.cmd [[highlight EndOfBuffer guifg=#${theme.colors.fg} guibg=#${theme.colors.bg}]]
    '';

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      clipboard = "unnamedplus";
      cursorline = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 50;
      conceallevel = 2; # Versteckt die Markdown-Sonderzeichen
    };

    globals.mapleader = " ";

    plugins = {
      # 1. BLINK.CMP
      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "default";
          appearance = {
            use_nvim_cmp_as_default = true;
            nerd_font_variant = "mono";
          };
          sources = {
            default = [ "lsp" "path" "snippets" "buffer" ];
          };
        };
      };

      # 2. RENDER-MARKDOWN
      render-markdown = {
        enable = true;
        settings = {
          file_types = [ "markdown" ]; # Nur noch Markdown
          latex.enabled = false;
          heading = {
            backgrounds = [ "" "" "" "" "" "" ]; # Keine klobigen Hintergründe mehr
            foregrounds = [
              "RenderMarkdownH1" "RenderMarkdownH2" "RenderMarkdownH3"
              "RenderMarkdownH4" "RenderMarkdownH5" "RenderMarkdownH6"
            ];
          };
        };
      };

      # 3. LSP & TOOLS
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          ansiblels = {
            enable = true;
            package = pkgs.ansible-language-server;
          };
          marksman.enable = true; # Der Markdown-Spezialist für Wiki-Links!
          bashls.enable = true;
        };
      };

      # 4. UI & NAVIGATION
      lualine.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
      telescope.enable = true;
      neo-tree.enable = true;
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
      };
      
      gitsigns.enable = true;
      neogit.enable = true;
    };

    extraConfigLuaPre = ''
      -- Verhindert lästige Direnv-Prompts
      vim.g.direnv_silent_load = 1

      -- Render Markdown Custom Colors (Orientiert am Horizon Skin)
      vim.cmd [[highlight RenderMarkdownH1 guifg=#${theme.colors.accent_primary} guibg=NONE gui=bold]]
      vim.cmd [[highlight RenderMarkdownH2 guifg=#${theme.colors.accent_secondary} guibg=NONE gui=bold]]
      vim.cmd [[highlight RenderMarkdownH3 guifg=#${theme.colors.term.blue} guibg=NONE gui=bold]]
      vim.cmd [[highlight RenderMarkdownH4 guifg=#${theme.colors.term.magenta} guibg=NONE gui=bold]]
      vim.cmd [[highlight RenderMarkdownH5 guifg=#${theme.colors.term.green} guibg=NONE gui=bold]]
      vim.cmd [[highlight RenderMarkdownH6 guifg=#${theme.colors.term.yellow} guibg=NONE gui=bold]]
      vim.cmd [[highlight RenderMarkdownCode guifg=#${theme.colors.fg} guibg=#${theme.colors.inactive_border}]]
      vim.cmd [[highlight RenderMarkdownCodeInline guifg=#${theme.colors.term.cyan} guibg=#${theme.colors.inactive_border}]]
      vim.cmd [[highlight RenderMarkdownBullet guifg=#${theme.colors.accent_primary}]]
      vim.cmd [[highlight RenderMarkdownQuote guifg=#${theme.colors.accent_tertiary}]]
    '';

    keymaps = [
      { action = "<cmd>Neotree toggle<CR>"; key = "<leader>e"; mode = "n"; options.desc = "Explorer"; }
      { action = "<cmd>Neogit<CR>"; key = "<leader>gg"; mode = "n"; options.desc = "Git"; }
    ];
  };
}
