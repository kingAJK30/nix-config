{ config, ... }: {
  flake.modules.nixos.desktop-utils = { ... }: {
    security.pam.services.swaylock = { };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

    home-manager.sharedModules = [ config.flake.modules.homeManager.desktop-utils ];
  };

  flake.modules.homeManager.desktop-utils = { pkgs, lib, ... }: {

    programs.swaylock.enable = true;
    services.swayidle = {
      enable = true;
      events = {
        before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
        lock = "${pkgs.swaylock}/bin/swaylock -f";
      };
      timeouts = [
        {
          timeout = 600;
          command = "${pkgs.swaylock}/bin/swaylock -f";
        }
        {
          timeout = 900;
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
