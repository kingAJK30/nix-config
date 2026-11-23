{ ... }: {
  home-manager.sharedModules = [
    {
      programs.waybar.settings.mainBar = {
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];

        modules-center = [ "sway/window" ];

        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "clock"
        ];
      };
    }
  ];
}
