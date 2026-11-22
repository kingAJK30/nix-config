{ ... }: {
  flake.modules.nixos.thunar = { pkgs, ... }: {
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [ thunar-archive-plugin ];
    };

    services.gvfs.enable = true;
    services.tumbler.enable = true;

    environment.systemPackages = [ pkgs.file-roller ];
  };
}
