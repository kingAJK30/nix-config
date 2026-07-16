{ lib, pkgs, ... }:

{
  home.packages = [
    pkgs.openscad
    pkgs.kicad
  ];
}
