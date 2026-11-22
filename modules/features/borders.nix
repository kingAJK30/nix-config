{ config, ... }: {
  flake.modules.nixos.borders = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.borders ];
  };

  flake.modules.homeManager.borders =
    { config, lib, ... }:
    let
      color = "#${config.lib.stylix.colors.base05}";
      inherit (config.lib.formats.rasi) mkLiteral;

      outline = {
        border = lib.mkForce color;
        childBorder = lib.mkForce color;
      };
    in
    {
      wayland.windowManager.sway.config = {
        window = {
          border = 1;
          titlebar = false;
        };
        floating = {
          border = 1;
          titlebar = false;
        };

        colors = {
          focused = outline;
          focusedInactive = outline;
          unfocused = outline;
        };
      };

      programs.rofi.theme.window = {
        border = lib.mkForce (mkLiteral "1px");
        border-color = lib.mkForce (mkLiteral color);
      };
    };
}
