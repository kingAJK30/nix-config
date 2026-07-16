{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      # Declare language tooling instances here
      servers = {
        nil_ls.enable = true;	# premium Nix language server
      	pyright.enable = true;	# strong Python diagnostics engine
	      ts_ls.enable = true;	# reliable modern TypeScript/JavaScript engine
        clangd.enable = true;   # C server
	      rust_analyzer = {
	        enable = true;
	        installCargo = false;
	        installRustc = false;
	      };
      };

      # Maps LSP capabilities directly to standard VIM shortcut definitions
      keymaps = {
        diagnostic = {
          "[d" = "goto_prev";
          "]d" = "goto_next";
          "<leader>do" = "open_float";
        };
        lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "gi" = "implementation";
          "K" = "hover";
          "<leader>cr" = "rename";
          "<leader>ca" = "code_action";
          "<leader>cl" = "format";
        };
      };
    };

    # UI Optimization for Errors: Displays inline virtual lines for quick tracking
    plugins.lsp-lines.enable = true;
  };
}
