{ config, inputs, ... }: {
  flake.modules.nixos.ly = { pkgs, ... }: {
    services.displayManager.ly.enable = true;
    home-manager.sharedModules = [ config.flake.modules.homeManager.ly ];
  };

  flake.modules.homeManager.ly = { pkgs, lib, ... }: {
  };
}
