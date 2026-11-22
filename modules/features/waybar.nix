{ config, inputs, ... }: {
  flake.modules.nixos.waybar = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.waybar ];
  };

  flake.modules.homeManager.waybar = { config, pkgs, lib, ... }: {
    programs.waybar = {
      enable = true;
      systemd.enable = false;

      settings.mainBar = {
	layer = lib.mkDefault "top";
	position = lib.mkDefault "top";
	height = lib.mkDefault 32;

	modules-left = lib.mkDefault [
	  "sway/workspaces"
	];

	modules-center = lib.mkDefault [
	  
	];

	modules-right = lib.mkDefault [
	  "clock"
	];

	"sway/workspaces" = {
	  format = "{name}";
	  all-outputs = true;
	};

	"sway/mode" = {
	  format = "<span style=\"italic\">{}</span>";
	};

	"sway/window" = {
	  max-length = 25;
	};

	pulseaudio = {
	  format = "VOL {volume}%";
	  format-muted = "VOL MUTED";
	  on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
	};

	network = {
	  format-wifi = "WIFI {essid} ({signalStrength}%)";
	  format-ethernet = "ETH";
	  format-disconnected = "OFFLINE";
	  tooltip-format = "{ifname}: {ipaddr}/{cidr}";
	};

	cpu = {
	  format = "CPU {usage}%";
          interval = 10;
	};

	memory = {
	  format = "RAM {percentage}%";
	  interval = 10;
	};

	temperature = {
	  critical-threshold = 80;
	  format = "TEMP {temperatureC}C";
	};

	battery = {
	  states = {
	    warning = 20;
	    critical = 15;
	  };
	  format = "BATT {capacity}%";
	  format-charging = "BATT CHG {capacity}%";
	};

	tray = {
	  spacing = 8;
	};

	clock = {
	  format = "{:%H:%M}";
	  tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
	};
      };
    };
    wayland.windowManager.sway.config.startup = lib.mkIf config.wayland.windowManager.sway.enable [
      { command = "${config.programs.waybar.package}/bin/waybar"; }
    ];
  };
}
