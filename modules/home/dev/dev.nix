{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    python3

    # Quickshell
    Quickshell
    kdePackages.qtdeclarative
  ];
}
