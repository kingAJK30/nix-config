{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    orca-slicer
    kicad
    openscad
    blender
  ];
}
