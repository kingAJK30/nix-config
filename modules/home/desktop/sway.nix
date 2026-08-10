{
  config,
  lib,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    #    extraOptions = [ "--unsupported-gpu" ];
    config = {
      modifier = "Mod4"; # Super
      terminal = config.services.globalTerminal;
      menu = config.services.globalMenu;

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+q" = "kill";
          "${modifier}+space" = "exec ${config.wayland.windowManager.sway.config.menu}";
        };

      gaps = {
        inner = 4;
        outer = 8;
      };

      output = {
        "DP-2" = {
          mode = "1920x1080@239.760Hz";
          pos = "0 0";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@74.986Hz";
          pos = "1920 0";
        };
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
        };
      };
    };
  };
}
