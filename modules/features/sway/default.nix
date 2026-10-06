{ lib, ... }: {
  flake.nixosModules.sway = { ... }: {
    programs.sway.enable = true;
  };

  flake.modules.homeManager.sway = {
    wayland.windowManager.sway = {
      enable = true;
      package = null;
      config = {
        modifier = lib.mkDefault "Mod4";
        terminal = lib.mkDefault "foot";
      };
    };
  };
}
