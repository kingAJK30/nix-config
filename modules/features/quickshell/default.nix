{ inputs, ... }: {
  flake.modules.homeManager.quickshell = { config, lib, pkgs, ... }: {
    home.packages = [ pkgs.quickshell ];

    xdg.configFile."quickshell".source = ./config;

    xdg.configFile."base16/colors.json".text =
      builtins.toJSON (lib.mapAttrs (_: c: "#${c}") config.my.colors);
  };
}
