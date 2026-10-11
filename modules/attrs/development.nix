{ self, inputs, ... }: {
  flake.nixosModules.attrs-development = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      cargo
    ];
  };

  flake.modules.homeManager.attrs-development = { pkgs, ... }: {
    imports = with self.modules.homeManager; [ nvim ];

    home.packages = with pkgs; [
      cargo
      inputs.rcat.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
