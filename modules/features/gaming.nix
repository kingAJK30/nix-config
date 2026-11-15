{ config, inputs, ... }: {
  flake.modules.nixos.gaming = { pkgs, ... }: {
    programs.steam.enable = true;
    home-manager.sharedModules = [ config.flake.modules.homeManager.gaming ];
  };

  flake.modules.homeManager.gaming = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
