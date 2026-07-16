{
  programs.nixvim = {
    plugins.luasnip.enable = true;

    plugins.cmp = {
      enable = true;
      settings = {
        autoEnableSources = true;
	snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

	# Priority mapping for item recommendations
	sources = [
	  { name = "nvim_lsp"; priority = 1000; }
	  { name = "luasnip"; priority = 750; }
	  { name = "buffer"; priority = 500; }
	  { name = "path"; priority = 250; }
	];

	mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
        };
      
        window = {
          completion.border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
          documentation.border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
        };
      };
    };
  };
}
