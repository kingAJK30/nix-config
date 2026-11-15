{ config, ... }: {
  flake.modules.nixos.git = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.git ];
  };

  flake.modules.homeManager.git = { pkgs, lib, ... }: {
    programs.git = {
      enable = true;

      extraConfig = lib.mapAttrs (_: lib.mkDefault) {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        fetch.prune = true;
        diff.colorMoved = "default";
        rerere.enabled = true;
      };

      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
        ".direnv/"
        "result"
        "result-*"
      ];
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = lib.mapAttrs (_: lib.mkDefault) {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
    };

    home.packages = with pkgs; [
      gh
    ];
  };
}
