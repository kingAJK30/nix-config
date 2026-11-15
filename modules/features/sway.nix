{ config, ... }: {
  flake.modules.nixos.sway = { ... }: {
    programs.sway.enable = true;
    home-manager.sharedModules = [ config.flake.modules.homeManager.sway ];
  };

  flake.modules.homeManager.sway =
    { config, lib, ... }:
    let
      cfg = config.wayland.windowManager.sway.config;
    in
    {
      wayland.windowManager.sway = {
        enable = true;
        package = null;
        config = {
          modifier = lib.mkDefault "Mod4";
          terminal = lib.mkDefault "foot";
          bars = lib.mkDefault [ ];

          keybindings = lib.mkOptionDefault {
            "${cfg.modifier}+q" = lib.mkDefault "kill";
            "${cfg.modifier}+Shift+q" = lib.mkDefault null;
            "${cfg.modifier}+space" = lib.mkDefault "exec ${cfg.menu}";
          };
        };
      };
    };
}
