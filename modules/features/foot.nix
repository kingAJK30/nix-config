{ config, ... }: {
  flake.modules.nixos.foot = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.foot ];
  };

  flake.modules.homeManager.foot = { lib, ... }: {
    programs.foot = {
      enable = true;

      settings = {
        main = {
          pad = lib.mkDefault "12x12";
        };

        scrollback = {
          lines = lib.mkDefault 10000;
          multiplier = lib.mkDefault 3.0;
        };

        mouse.hide-when-typing = lib.mkDefault "yes";
      };
    };

    home.sessionVariables.TERMINAL = lib.mkDefault "foot";
  };
}
