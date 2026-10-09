{ ... }: {
  flake.nixosModules.sway = { ... }: {
    programs.sway.enable = true;
  };

  flake.modules.homeManager.sway = { config, lib, ... }:
    let
      cfg = config.wayland.windowManager.sway.config;
      mod = config.wayland.windowManager.sway.config.modifier;
    in {
      wayland.windowManager.sway = {
        enable = true;
        package = null;
        config = {
          modifier = lib.mkDefault "Mod4";
          terminal = lib.mkDefault "foot";

          keybindings = lib.mkOptionDefault {
            "${mod}+q" = lib.mkDefault "kill";
            "${mod}+Shift+q" = lib.mkDefault null;

	    "${mod}+space" = lib.mkDefault "exec ${cfg.menu}";
          };
        };
      };
    };
}
