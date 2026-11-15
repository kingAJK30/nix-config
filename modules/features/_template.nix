{ config, inputs, ... }: {
  flake.modules.nixos.NAME = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.NAME ];
  };

  flake.modules.homeManager.NAME = { pkgs, lib, ... }: {
  };
}
