{ config, inputs, ... }: {
  flake.modules.nixos.emacs = { ... }: {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
    home-manager.sharedModules = [ config.flake.modules.homeManager.emacs ];
  };

  flake.modules.homeManager.emacs = { pkgs, lib, ... }: {
    imports = [ inputs.nix-doom-emacs-unstraightened.hmModule ];

    programs.doom-emacs.enable = true;

    services.emacs.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      ripgrep
      fd
      kdePackages.qtdeclarative
      nixd
      rust-analyzer
      pyright
    ];

    home.shellAliases = {
      emacs = lib.mkDefault "emacsclient -t";
      emacsg = lib.mkDefault "emacsclient -c";
    };
  };
}
