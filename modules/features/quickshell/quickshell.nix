{ config, ... }: {
  flake.modules.nixos.quickshell = { ... }: {
    home-manager.sharedModules = [ config.flake.modules.homeManager.quickshell ];
  };

  flake.modules.homeManager.quickshell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      color = config.lib.stylix.colors.withHashtag;
      font = config.stylix.fonts;

      home = config.home.homeDirectory;
      configDir = "${home}/src/nix-refactor/modules/features/quickshell";
    in
    {
      home.packages = [ pkgs.quickshell ];

      wayland.windowManager.sway.config.startup = lib.mkIf config.wayland.windowManager.sway.enable [
        { command = "${pkgs.quickshell}/bin/quickshell"; }
      ];

      xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink configDir;

      home.file."${lib.removePrefix "${home}/" configDir}/theme.json".text = builtins.toJSON {
        colors = {
          bg = color.base00;
          surface = color.base01;
          dim = color.base04;
          fg = color.base05;
          border = color.base05;
          accent = color.base0D;
          red = color.base08;
          yellow = color.base0A;
          green = color.base0B;
        };
        fonts = {
          mono = font.monospace.name;
          size = font.sizes.desktop;
        };
      };
    };
}
