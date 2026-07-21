{ lib, ... }: {
  imports = lib.filter 
    (file: lib.hasSuffix ".nix" (builtins.toString file) && !(lib.hasSuffix "default.nix" (builtins.toString file)))
    (lib.filesystem.listFilesRecursive ./.);
}
