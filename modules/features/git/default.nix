{ self, inputs, ... }: {
  flake.nixosModules.Git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      
      config = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        pull.rebase = true;
      };
    };

    environment.systemPackages = with pkgs; [
      gh
      delta
    ];
  };
}
