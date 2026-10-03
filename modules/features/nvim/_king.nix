{ pkgs }: {
  runtimePkgs = with pkgs; [
    ripgrep fd
    nixd nixpkgs-fmt # Nix tooling
    rust-analyzer # Rust LSP
    lua-language-server # Lua LSP
    pyright # Python LSP
  ];

  specs = {
    treesitter.data = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

    general.config = ''
      -- Basics & UI
      vim.g.mapleader = " "
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.signcolumn = "yes"
      
      -- Native File Navigation & Netrw
      vim.opt.path:append("**")
      vim.opt.wildignore:append({ "*/.git/*", "*/node_modules/*", "*/target/*" })
      vim.keymap.set("n", "<leader>f", ":find ", { desc = "Find File" })
      vim.keymap.set("n", "<leader>b", ":b ", { desc = "Switch Buffer" })
      vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Native Explorer" })

      -- Native Treesitter Highlighting
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args) pcall(vim.treesitter.start, args.buf) end,
      })

      -- Native LSP Client Connection
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "nix", "rust", "lua", "python" },
        callback = function(args)
          local servers = {
            nix = "nixd",
            rust = "rust-analyzer",
            lua = "lua-language-server",
            python = "pyright"
          }
          local cmd = servers[vim.bo.filetype]
          if cmd and vim.fn.executable(cmd) == 1 then
            vim.lsp.start({
              name = cmd,
              cmd = { cmd },
              root_dir = vim.fs.root(args.buf, {".git", "flake.nix", "Cargo.toml"})
            })
          end
        end,
      })

      -- LSP Keymaps, Diagnostics, and Native Completion
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(keys, func) 
            vim.keymap.set("n", keys, func, { buffer = args.buf }) 
          end
          
          map("gd", vim.lsp.buf.definition)
          map("K", vim.lsp.buf.hover)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
          map("<leader>d", vim.diagnostic.open_float)
          
          -- Enable Native Omni-Completion (Trigger with Ctrl+X, Ctrl+O in Insert Mode)
          vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end,
      })
    '';
  };
}
