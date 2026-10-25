{ inputs, ... }: {
  flake.nixosModules.emacs = { pkgs, ... }: {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
  };

  flake.modules.homeManager.emacs = { pkgs, ... }: {
    imports = [ inputs.nix-doom-emacs-unstraightened.hmModule ];

    programs.doom-emacs = {
      enable = true;
    };

    home.packages = with pkgs; [
      ripgrep
      fd
      kdePackages.qtdeclarative
    ];
  };
}
