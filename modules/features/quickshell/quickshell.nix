{ config, inputs, ... }: {
  flake.modules.nixos.quickshell = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.quickshell ];
  };

  flake.modules.homeManager.quickshell = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      quickshell
    ];
  };
}
