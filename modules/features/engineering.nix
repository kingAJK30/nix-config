{ config, inputs, ... }: {
  flake.modules.nixos.engineering = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.engineering ];
  };

  flake.modules.homeManager.engineering = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      bambu-studio
      openscad
    ];
  };
}
