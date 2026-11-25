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

          gaps = {
            inner = lib.mkDefault 2;
            outer = lib.mkDefault 0;
          };

          keybindings = lib.mkOptionDefault {
            "${cfg.modifier}+q" = lib.mkDefault "kill";
            "${cfg.modifier}+shift+q" = lib.mkDefault null;

	    "${cfg.modifier}+space" = lib.mkDefault "exec quickshell ipc call launcher open";

	    "${cfg.modifier}+a" = lib.mkDefault "exec quickshell ipc call ask open";

	    "${cfg.modifier}+c" = lib.mkDefault "exec quickshell ipc call control open";

	    "${cfg.modifier}+shift+escape" = lib.mkDefault "exec quickshell ipc call lock lock";

	    "${cfg.modifier}+Escape" = lib.mkDefault "exec quickshell ipc call session open";

            "${cfg.modifier}+n" = lib.mkDefault "exec quickshell ipc call dnd toggle";

            "${cfg.modifier}+shift+p" =
              lib.mkDefault ''exec grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy'';

            "${cfg.modifier}+shift+v" = lib.mkDefault "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
          };
        };
      };
    };
}
