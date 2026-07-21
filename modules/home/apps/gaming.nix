{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    steam
    prism-launcher
  ];
}
