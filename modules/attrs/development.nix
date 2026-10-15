{ self, inputs, ... }: {
  flake.nixosModules.attrs-development = { pkgs, ... }: {
    imports = with self.nixosModules; [ llm ];

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };

  flake.modules.homeManager.attrs-development = { pkgs, ... }: {
    imports = with self.modules.homeManager; [ ];

    home.packages = with pkgs; [
      cargo
      inputs.rcat.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
