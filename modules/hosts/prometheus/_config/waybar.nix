{ lib, ... }: {
  home-manager.users.king.programs.waybar = {
    settings.mainBar = {
      modules-left = [
        "sway/workspaces"
        "sway/mode"
      ];

      modules-center = [
        "sway/window"
      ];

      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "clock"
      ];
    };

  style = lib.mkAfter ''
   window#waybar {
     border-bottom: 1px solid currentColor;
   }

   #mode,
   #tray,
   #pulseaudio,
   #network,
   #cpu,
   #memory,
   #clock {
     padding: 0 0.7em;
     border-left: 1px solid currentColor;
   }
  '';
  };
}
