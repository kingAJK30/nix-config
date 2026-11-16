{ config, inputs, ... }: {
  flake.modules.nixos.waybar = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.waybar ];
  };

  flake.modules.homeManager.waybar = { pkgs, lib, ... }: {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 32;
          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ "sway/window" ];
          modules-right = [ "pulseaudio" "network" "cpu" "memory" "clock" ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            format = "{name}";
          };

          clock = {
            format = "{:%H:%M - %Y-%m-%d}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          cpu = {
            format = "CPU: {usage}%";
            interval = 5;
          };

          memory = {
            format = "RAM: {percentage}%";
            interval = 5;
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = "Muted";
            format-icons = {
              default = [ "" "" "" ];
            };
            on-click = "pavucontrol";
          };

          network = {
            format-wifi = "{essid} ({signalStrength}%)";
            format-ethernet = "Ethernet";
            format-disconnected = "Disconnected";
          };
        };
      };
    };
  };
}
