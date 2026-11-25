{ config, inputs, ... }: {
  flake.modules.nixos.quickshell = { ... }: {
    imports = [ inputs.quickshell-config.nixosModules.default ];
    home-manager.sharedModules = [ config.flake.modules.homeManager.quickshell ];
  };

  flake.modules.homeManager.quickshell =
    { config, ... }:
    let
      color = config.lib.stylix.colors.withHashtag;
      font = config.stylix.fonts;
    in
    {
      imports = [ inputs.quickshell-config.homeManagerModules.default ];

      programs.quickshell.theme = {
        wallpaper = toString config.stylix.image;
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
