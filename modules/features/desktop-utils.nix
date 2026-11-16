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
    services.swaync.enable = true;

    programs.swaylock.enable = true;
    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
        { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      ];
      timeouts = [
        { timeout = 600; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      ];
    };

    home.packages = with pkgs; [
      grim
      slurp
      satty
      wl-clipboard
      cliphist
    ];
  };
}
