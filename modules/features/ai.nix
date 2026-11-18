{ config, inputs, ... }: {
  flake.modules.nixos.ai = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.ai ];
  };

  flake.modules.homeManager.ai = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      claude-code
      rtk
    ];
  };
}
