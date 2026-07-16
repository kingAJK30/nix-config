{
  # Stylix configuration specific for Nixvim
  stylix.targets.nixvim = {
    enable = true;
    transparentBackground = {
      main = true;
      signColumn = true;
    };
  };

  programs.nixvim = {
    plugins.lualine = {
      enable = true;

      settings = {
        options = {
	  component_separators = { left = "│"; right = "│"; };
          section_separators = { left = ""; right = ""; };
	};
      };
    };

    plugins.gitsigns.enable = true;
    plugins.colorizer.enable = true;
  };
}
