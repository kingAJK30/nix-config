{ config, ... }: {
  flake.modules.nixos.yazi = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.yazi ];
  };

  flake.modules.homeManager.yazi = { lib, ... }: {
    programs.yazi = {
      enable = true;

      settings.mgr = lib.mapAttrs (_: lib.mkDefault) {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
    };
  };
}
