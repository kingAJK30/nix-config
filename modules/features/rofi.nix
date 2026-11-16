{ config, ... }: {
  flake.modules.nixos.rofi = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.rofi ];
  };

  flake.modules.homeManager.rofi = { config, lib, ... }: {
    programs.rofi = {
      enable = true;
      extraConfig = {
        modi = lib.mkDefault "drun,run";
        show-icons = lib.mkDefault true;
      };
    };

    wayland.windowManager.sway.config.menu = lib.mkIf config.wayland.windowManager.sway.enable (
      lib.mkDefault "rofi -show drun"
    );
  };
}
