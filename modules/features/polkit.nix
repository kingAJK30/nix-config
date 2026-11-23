{ config, inputs, ... }: {
  flake.modules.nixos.polkit = { pkgs, ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.polkit ];
  };

  flake.modules.homeManager.polkit =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      wayland.windowManager.sway.config.startup = lib.mkIf config.wayland.windowManager.sway.enable [
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
      ];
    };
}
