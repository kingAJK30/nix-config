{ ... }: {
  flake.modules.homeManager.files = { pkgs, ...  }: {
    home.packages = with pkgs; [
      yazi
      thunar
    ];
  };
}
