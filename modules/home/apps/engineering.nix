{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bambu-studio
    kicad
    openscad
    (blender.override { cudaSupport = true; })
  ];
}
