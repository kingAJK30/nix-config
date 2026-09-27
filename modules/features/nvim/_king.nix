{ pkgs }: {
  runtimePkgs = with pkgs; [
    ripgrep
    fd
    tree-sitter

    nixd
    nixpkgs-fmt
    rust-analyzer
    cargo
    rustc
    lua-language-server
    typescript-language-server
    pyright
    clang-tools
    gopls
    vscode-langservers-extracted
  ];

  specs = {
    general = {
      config = ''
        -- Globals & Options
        vim.g.mapleader = " "
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.shiftwidth = 2

        -- Keymaps
        vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<CR>")

        -- Highlights
        vim.api.nvim_set_hl(0, "Comment", {
          fg = "#ff00ff",
          bg = "#000000",
          underline = true,
          bold = true,
        })
      '';
    };

    gruvbox = {
      data = pkgs.vimPlugins.gruvbox-nvim;
      config = "vim.cmd[[colorscheme gruvbox]]";
    };

    web-devicons = {
      data = pkgs.vimPlugins.nvim-web-devicons;
    };

    lualine = {
      data = pkgs.vimPlugins.lualine-nvim;
      config = "require('lualine').setup{}";
    };

    telescope = {
      data = pkgs.vimPlugins.telescope-nvim;
      config = "require('telescope').setup{}";
    };

    oil = {
      data = pkgs.vimPlugins.oil-nvim;
      config = "require('oil').setup{}";
    };

    treesitter = {
      data = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      config = "require('nvim-treesitter.configs').setup{ highlight = { enable = true } }";
    };

    lspconfig = {
      data = pkgs.vimPlugins.nvim-lspconfig;
      config = ''
        local lspconfig = require('lspconfig')

        lspconfig.nixd.setup{
          settings = {
            formatting = { command = { "nixpkgs-fmt" } }
          }
        }
        lspconfig.rust_analyzer.setup{}
        lspconfig.lua_ls.setup{
          settings = {
            Lua = { diagnostics = { globals = { "vim" } } }
          }
        }
        lspconfig.ts_ls.setup{}
        lspconfig.pyright.setup{}
        lspconfig.clangd.setup{}
        lspconfig.gopls.setup{}
        lspconfig.html.setup{}
        lspconfig.cssls.setup{}
      '';
    };

    cmp = {
      data = pkgs.vimPlugins.nvim-cmp;
      config = ''
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
          }, {
            { name = "buffer" },
          }),
          mapping = {
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }
        })
      '';
    };

    cmp_sources = {
      data = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        cmp-path
        cmp-buffer
        cmp_luasnip
        luasnip
      ];
    };
  };
}
