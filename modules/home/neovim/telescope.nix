{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      # Assign the IDE style shortcut functions
      keymaps = {
        "<leader>ff" = { action = "find_files"; options.desc = "Find Files Globally"; };
        "<leader>fg" = { action = "live_grep"; options.desc = "Grep Search across codebase"; };
        "<leader>fb" = { action = "buffers"; options.desc = "Find Active Buffers"; };
        "<leader>fh" = { action = "help_tags"; options.desc = "Search Vim Help manuals"; };
        "<leader>gf" = { action = "git_files"; options.desc = "Search Tracked Git Files"; };
      };

      settings = {
        defaults = {
	  file_ignore_patterns = [ "^.git/" "^node_modules/" ];
	  sorting_strategy = "ascending";
	  layout_config = {
	    horizontal = { prompt_position = "top"; preview_width = 0.55; };
	  };
	};
      };
    };
  };
}
