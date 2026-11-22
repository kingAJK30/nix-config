{ lib, ... }:
{
  imports = lib.filter
    (f: lib.hasSuffix ".nix" (toString f) && baseNameOf f != "default.nix")
    (lib.filesystem.listFilesRecursive ./.);
}
