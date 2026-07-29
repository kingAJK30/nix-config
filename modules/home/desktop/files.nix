{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    yazi
    thunar
    vesktop
  ];
}
