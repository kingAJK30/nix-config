{ ... }: {
  home-manager.sharedModules = [
    {
      wayland.windowManager.sway.config.output = {
        "DP-2" = {
          mode = "1920x1080@239.760Hz";
          pos = "0 0";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@74.986Hz";
          pos = "1920 0";
        };
      };
    }
  ];
}
