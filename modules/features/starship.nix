{ config, inputs, ... }: {
  flake.modules.nixos.starship = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.starship ];
  };

  flake.modules.homeManager.starship = { ... }: {
    programs.starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };
  };
}
