{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # Grundeinstellungen für eine moderne IDE
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      clipboard = "unnamedplus"; # System-Clipboard nutzen
      cursorline = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 50; # Schnellere Reaktionszeit
    };

    # Catppuccin Mocha Theme (passend zu deinem System)
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = true; # Passend zu deiner Foot-Terminal Transparenz
      };
    };

    # Leader-Taste auf Space legen
    globals.mapleader = " ";

    plugins = {
      # 1. UI & Ästhetik
      lualine.enable = true; # Schicke Statusleiste
      web-devicons.enable = true;
      which-key.enable = true; # Zeigt Tastenkürzel-Hilfen an
      
      # 2. Syntax Highlighting (Treesitter)
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # 3. Fuzzy Finder (Telescope)
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
        };
      };

      # 4. Datei-Explorer (Neo-tree)
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
        };
      };

      # 5. Language Server Protocol (LSP) - Das Gehirn der IDE
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true; # Perfekt für NixOS Flakes
          bashls.enable = true;
          # Hier kannst du weitere Server aktivieren (z.B. rust_analyzer, pyright, tsserver)
        };
        keymaps.lspBuf = {
          gd = "definition";
          gr = "references";
          K = "hover";
          "<leader>rn" = "rename";
        };
      };

      # 6. Autocompletion (CMP)
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };

      # 7. Git Integration
      gitsigns.enable = true;
      fugitive.enable = true;
    };

    # Keybinds für den Explorer
    keymaps = [
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<leader>e";
        mode = "n";
        options = { desc = "Toggle File Explorer"; };
      }
    ];
  };
}
