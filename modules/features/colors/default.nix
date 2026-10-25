{ ... }: {
  flake.modules.homeManager.colors = { lib, ... }: {
    options.my.colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "Base16 palette, hex without the leading #.";
    };

    config.my.colors = lib.mkDefault {
      base00 = "f8f8f2"; base01 = "efefe9"; base02 = "deded8"; base03 = "c0c0bd";
      base04 = "60615d"; base05 = "232629";
      base08 = "b0151a"; base09 = "ff3d00"; base0A = "ffb627"; base0B = "388e3c";
      base0D = "0082c9"; base0E = "700f98";
    };
  };
}
