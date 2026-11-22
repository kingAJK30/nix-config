{ ... }: {
  flake.modules.nixos.cursor = { pkgs, lib, ... }: {
    stylix.cursor = {
      package = lib.mkDefault pkgs.posy-cursors;
      name = lib.mkDefault "Posy_Cursor";
      size = lib.mkDefault 32;
    };
  };
}
