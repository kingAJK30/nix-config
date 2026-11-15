{ config, inputs, ... }: {
  flake.modules.nixos.nvim = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.nvim ];
  };

  flake.modules.homeManager.nvim = { pkgs, lib, ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      globals.mapleader = lib.mkDefault " ";

      opts = lib.mapAttrs (_: lib.mkDefault) {
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

      extraPackages = with pkgs; [
        ripgrep
        fd
        tree-sitter
        nixfmt
      ];

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
            nixd = {
              enable = true;
              settings.formatting.command = [ "nixfmt" ];
            };
            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
            lua_ls = {
              enable = true;
              settings.diagnostics.globals = [ "vim" ];
            };
            ts_ls = {
              enable = true;
              filetypes = [
                "javascript"
                "javascriptreact"
                "typescript"
                "typescriptreact"
              ];
            };
            pyright.enable = true;
            clangd.enable = true;
            gopls.enable = true;
            html.enable = true;
            cssls.enable = true;
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
              "<CR>".__raw = "cmp.mapping.confirm({ select = true })";
              "<Tab>".__raw = ''
                cmp.mapping(function(fallback)
                  local luasnip = require("luasnip")
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';
              "<S-Tab>".__raw = ''
                cmp.mapping(function(fallback)
                  local luasnip = require("luasnip")
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
