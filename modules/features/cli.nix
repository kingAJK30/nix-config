{ config, inputs, ... }: {
  flake.modules.nixos.cli = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.cli ];
  };

  flake.modules.homeManager.cli = { pkgs, ... }: {
    home.packages = with pkgs; [
      nixfmt-tree
      tree
      unzip
      wget
      curl
      inputs.rcat.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
