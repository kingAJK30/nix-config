{ self, ... }: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.gruvbox.enable = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    keymaps = [
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>g";
      }
    ];

    highlight = {
      Comment.fg = "#ff00ff";
      Comment.bg = "#000000";
      Comment.underline = true;
      Comment.bold = true;
    };

    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;
      telescope.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;

      lsp = {
        enable = true;
        servers = {
          # Nix
          nixd = {
            enable = true;
            settings.formatting.command = [ "nixpkgs-fmt" ];
          };

          # Rust
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };

          pyright.enable = true; # Python
          clangd.enable = true; # C / C++
          gopls.enable = true; # Go
          lua_ls = { # Lua
            enable = true;
            settings.diagnostics.globals = [ "vim" ];
          };
          html.enable = true; # HTML
          cssls.enable = true; # CSS
          ts_ls.enable = true; # JavaScript / TypeScript
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];

          mapping = {
            "<CR>" = { __raw = "cmp.mapping.confirm({ select = true })"; };
            "<Tab>" = {
              __raw = ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';
            };
            "<S-Tab>" = {
              __raw = ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';
            };
          };
        };
      };
    };
  };
}
