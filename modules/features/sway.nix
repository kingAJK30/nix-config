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
            "${cfg.modifier}+shift+q" = lib.mkDefault null;

            "${cfg.modifier}+space" = lib.mkDefault "exec ${cfg.menu}";

            "${cfg.modifier}+shift+l" = lib.mkDefault "exec swaylock -f";

            "${cfg.modifier}+n" = lib.mkDefault "exec swaync-client -t -sw";

            "${cfg.modifier}+shift+p" = lib.mkDefault ''exec grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy'';

            "${cfg.modifier}+shift+v" = lib.mkDefault "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
          };
        };
      };
    };
}
