{
  programs.nixvim = {
    globals.mapleader = " "; # set the Leader key globally

    # Core Neovim settings
    opts = {
      number = true;		      # show line numbers
      relativenumber = true;	# use relative numberse for quick vertical jumps
      shiftwidth = 2;		      # indent size
      tabstop = 2;		        # tab width
      expandtab = true;		    # use spaces instead of actual tabs
      smartindent = true;		  # dynamic auto-indenting
      wrap = false;		        # prevent text from wrapping lines automatically
      swapfile = true;		    # avoid messy swap files lingering
      backup = false;		      # skip creation of automatic backup files
      undofile = true;		    # maintain persistent undo history across restarts
      hlsearch = false;		    # drop persistent highlights after searches clear
      incsearch = true;		    # jump dynamically to search entries while typing
      termguicolors = true;	  # truecolor support required for modern ricing
      scrolloff = 8;		      # keep 8 lines visible at bottom/top margins
      foldlevel = 99;         # folds start with a higher level than this will be closed
      foldlevelstart = 99;    # start with all folds open when opening a file
    };

    keymaps = [
      # Clear highlights quickly
      { mode = "n"; key = "<leader>h"; action = "<cmd>nohlsearch<CR>"; options.desc = "Clear search highlights"; }

      # Window Management
      { mode = "n"; key = "<leader>sv"; action = "<cmd>vsplit<CR>"; options.desc = "Split Window Vertically"; }
      { mode = "n"; key = "<leader>sh"; action = "<cmd>split<CR>"; options.desc = "Split Window Horizontally"; }
      
      # Buffer Navigation
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<CR>"; options.desc = "Next Buffer"; }
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<CR>"; options.desc = "Previous Buffer"; }
    ];
  };
}
