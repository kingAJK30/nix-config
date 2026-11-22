{ config, ... }: {
  flake.modules.nixos.swaync = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.swaync ];
  };

  flake.modules.homeManager.swaync = { lib, ... }: {
    services.swaync = {
      enable = true;

      settings = {
        positionX = "right";
        positionY = "top";
        control-center-margin-top = 2;
        control-center-margin-right = 2;
        control-center-margin-bottom = 2;
        control-center-margin-left = 0;
        notification-window-width = 400;
        control-center-width = 400;
        hide-on-clear = true;
        hide-on-action = true;

        widgets = [ "title" "dnd" "notifications" ];
        widget-config = {
          title = {
            text = "NOTIFICATIONS";
            clear-all-button = true;
            button-text = "CLEAR";
          };
          dnd.text = "DO NOT DISTURB";
        };
      };

      style = lib.mkAfter ''
        .control-center,
        .notification-row .notification-background .notification {
          border: 1px solid currentColor;
          border-radius: 0;
        }

        .widget-title > button {
          border: 1px solid currentColor;
          border-radius: 0;
        }

        .close-button {
          border-radius: 0;
        }
      '';
    };
  };
}
