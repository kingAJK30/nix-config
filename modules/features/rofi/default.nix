{ lib, ... }: {
  flake.modules.homeManager.rofi = {
    programs.rofi = {
      enable = true;
      extraConfig = {
        modes = lib.mkDefault "drun";
        show-icons = lib.mkDefault false;
      };
    };
  };
}
