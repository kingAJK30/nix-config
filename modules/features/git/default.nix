{ ... }: {
  flake.modules.homeManager.git = { lib, ... }: {
    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
        core.editor = lib.mkDefault "nvim";
      };
    };

    programs.gh.enable = true;
  };
}
