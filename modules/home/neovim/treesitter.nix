{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      # Automatically sync and install language parsers
      folding.enable = true;

      settings = {
        ensure_installed = [
      	  "nix"
          "lua"
          "python"
          "markdown"
          "javascript"
          "typescript"
          "rust"
          "bash"
          "json"
          "c"
	];
        highlight.enable = true;
	indent.enable = true;
      };
    };
  };
}
