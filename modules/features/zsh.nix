{ config, inputs, ... }: {
  flake.modules.nixos.zsh = { pkgs, lib, ... }: {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    home-manager.sharedModules = [ config.flake.modules.homeManager.zsh ];
  };

  flake.modules.homeManager.zsh = { pkgs, lib, ... }: {
    programs.fzf.enable = true;
    programs.zoxide.enable = true;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;

      history = lib.mapAttrs (_: lib.mkDefault) {
        size = 10000;
        ignoreAllDups = true;
        share = true;
      };

      shellAliases = lib.mapAttrs (_: lib.mkDefault) {
        ll = "ls -lah";
      };
    };
  };
}
