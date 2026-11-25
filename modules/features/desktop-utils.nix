{ config, ... }: {
  flake.modules.nixos.desktop-utils = { ... }: {
    security.pam.services.quickshell-lock = { };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

    home-manager.sharedModules = [ config.flake.modules.homeManager.desktop-utils ];
  };

  flake.modules.homeManager.desktop-utils = { pkgs, lib, ... }: {

    services.swayidle = {
      enable = true;
      events = {
	before-sleep = "${pkgs.quickshell}/bin/quickshell ipc call lock lock";
	lock = "${pkgs.quickshell}/bin/quickshell ipc call lock lock";
      };
      timeouts = [
        {
          timeout = 1800;
	  command = "${pkgs.quickshell}/bin/quickshell ipc call lock lock";
        }
        {
          timeout = 3600;
	  command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
      resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\"";
        }
      ];
    };

    home.packages = with pkgs; [
      grim
      slurp
      satty
      wl-clipboard
      cliphist
    ];

    wayland.windowManager.sway.config.startup = [
      {
        command = "systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK";
      }
      { command = "wl-paste --type text --watch cliphist store"; }
      { command = "wl-paste --type image --watch cliphist store"; }
    ];
  };
}
