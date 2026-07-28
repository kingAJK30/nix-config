{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    python3
    quickshell
    kdePackages.qtdeclarative
  ];
}
