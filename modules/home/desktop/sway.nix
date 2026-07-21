{
  config,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4"; #Super
      terminal = config.services.globalTerminal;
      menu = config.services.globalMenu;

      gaps = {
        inner = 4;
        outer = 8;
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
        };
      };
    };
  };
}
