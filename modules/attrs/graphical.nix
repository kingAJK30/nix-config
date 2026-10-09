{ self, ... }: {
  flake.nixosModules.attrs-graphical = { ... }: {
    imports = with self.nixosModules; [ fonts audio ];

    programs.steam.enable = true;
  };

  flake.modules.homeManager.attrs-graphical = { pkgs, ... }: {
    imports = with self.modules.homeManager; [ foot ];

    programs.firefox.enable = true;

    home.packages = with pkgs; [
      vesktop
      bambu-studio
      prismlauncher
    ];
  };
}
