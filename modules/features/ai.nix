{ config, inputs, ... }: {
  flake.modules.nixos.claude = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.claude ];
  };

  flake.modules.homeManager.claude = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      claude-code
      rtk
    ];
  };
}
